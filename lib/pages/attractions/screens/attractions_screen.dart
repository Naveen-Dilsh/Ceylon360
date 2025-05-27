import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'attraction_detail_screen.dart';

class AttractionsScreen extends StatefulWidget {
  const AttractionsScreen({super.key});

  @override
  _AttractionsScreenState createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  List places = [];
  String apiKey = 'AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM';
  final searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttractions();
  }

  Future<void> fetchAttractions() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=tourist+attractions+in+Sri+Lanka&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          places = data['results'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching attractions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> fetchPlaceDescription(String placeId) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=editorial_summary,reviews,formatted_address&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      if (result['editorial_summary'] != null) {
        return result['editorial_summary']['overview'];
      } else if (result['reviews'] != null && result['reviews'].isNotEmpty) {
        return result['reviews'][0]['text'];
      } else if (result['formatted_address'] != null) {
        return 'Located at: ${result['formatted_address']}';
      } else {
        return 'No description available for this attraction.';
      }
    } else {
      return 'Description fetch failed. Please check your internet connection.';
    }
  }

  String? getPhotoUrl(dynamic photoReference) {
    if (photoReference == null) return null;
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
  }

  void _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) {
      fetchAttractions(); // Reset to default attractions
      return;
    }

    setState(() {
      isLoading = true;
    });

    final searchUrl = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query+in+Sri+Lanka&key=$apiKey',
    );

    try {
      final response = await http.get(searchUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          places = data['results'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error searching attractions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search Destinations in Sri Lanka...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  _onSearchSubmitted('');
                },
              ),
            ),
            onSubmitted: _onSearchSubmitted,
          ),
        ),
        Expanded(
          child:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : places.isEmpty
                  ? Center(
                    child: Text(
                      'No attractions found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                  : ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      final photoReference =
                          place['photos'] != null && place['photos'].isNotEmpty
                              ? place['photos'][0]['photo_reference']
                              : null;
                      final photoUrl = getPhotoUrl(photoReference);

                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: InkWell(
                          onTap: () async {
                            final placeId = place['place_id'];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Loading details...'),
                                duration: Duration(seconds: 1),
                              ),
                            );

                            final description = await fetchPlaceDescription(
                              placeId,
                            );

                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AttractionDetailScreen(
                                      name: place['name'],
                                      description: description,
                                      photoUrl: photoUrl,
                                      lat: place['geometry']['location']['lat'],
                                      lng: place['geometry']['location']['lng'],
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      photoUrl != null
                                          ? Image.network(
                                            photoUrl,
                                            width: 100,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey[600],
                                                ),
                                              );
                                            },
                                          )
                                          : Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.photo,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        place['formatted_address'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            place['rating']?.toString() ??
                                                'N/A',
                                            style: TextStyle(
                                              color: Colors.orange[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          icon: Icon(Icons.info_outline),
                                          label: Text("See Details"),
                                          onPressed: () async {
                                            final placeId = place['place_id'];
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Loading details...',
                                                ),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );

                                            final description =
                                                await fetchPlaceDescription(
                                                  placeId,
                                                );

                                            if (!mounted) return;

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (
                                                      _,
                                                    ) => AttractionDetailScreen(
                                                      name: place['name'],
                                                      description: description,
                                                      photoUrl: photoUrl,
                                                      lat:
                                                          place['geometry']['location']['lat'],
                                                      lng:
                                                          place['geometry']['location']['lng'],
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
