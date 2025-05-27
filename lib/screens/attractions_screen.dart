import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'attraction_detail_screen.dart';
import 'events_screen.dart';
import 'tours_screen.dart';
import 'reviews_screen.dart';

class AttractionsScreen extends StatefulWidget {
  const AttractionsScreen({super.key});

  @override
  _AttractionsScreenState createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen>
    with SingleTickerProviderStateMixin {
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
    setState(() => isLoading = true);
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching attractions: $e');
      setState(() => isLoading = false);
    }
  }

  void _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) {
      fetchAttractions();
      return;
    }

    setState(() => isLoading = true);
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error searching attractions: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attractions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Attractions'),
              Tab(text: 'Events'),
              Tab(text: 'Tours'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildAttractionsTab(),
            const EventsScreen(),
            const TourScreen(),
            const ReviewScreen(),
          ],
        ),
      ),
    );
  }

  Widget buildAttractionsTab() {
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
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : places.isEmpty
                  ? const Center(child: Text('No attractions found'))
                  : ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        final photoReference = place['photos'] != null &&
                                place['photos'].isNotEmpty
                            ? place['photos'][0]['photo_reference']
                            : null;
                        final photoUrl = getPhotoUrl(photoReference);

                        return buildAttractionCard(place, photoUrl);
                      },
                    ),
        ),
      ],
    );
  }

  Widget buildAttractionCard(place, String? photoUrl) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: photoUrl != null
                  ? Image.network(
                      photoUrl,
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place['formatted_address'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(place['rating']?.toString() ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final placeId = place['place_id'];

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
                            builder: (_) => AttractionDetailScreen(
                              name: place['name'],
                              description: description,
                              photoUrl: photoUrl,
                              lat: place['geometry']['location']['lat'],
                              lng: place['geometry']['location']['lng'],
                            ),
                          ),
                        );
                      },
                      child: const Text('See Details '),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        return 'No description available.';
      }
    } else {
      return 'Failed to fetch description.';
    }
  }

  String? getPhotoUrl(dynamic photoReference) {
    if (photoReference == null) return null;
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
  }
}
