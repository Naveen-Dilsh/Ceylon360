import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/hotels/hotel_list_screen.dart';


import 'data/repositories/authentication/authentication_repository.dart';
import 'features/authentication/screens/login/login.dart';
import 'features/personalization/screens/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/translation/translation_screen.dart';
import '../pages/currency/currency_converter_screen.dart';
import '../pages/emergency/emergency_screen.dart';
import '../pages/contact/contacts_screen.dart';
import '../pages/transport/map_page.dart';
import '../pages/attractions/attractions.dart';
import 'screens/hotels/hotel_list_screen.dart';
// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 2, startX = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Destination {
  final String name;
  final String location;
  final String rating;
  final String price;
  final String photoReference;

  Destination({
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.photoReference,
  });
}

class Hotel {
  final String name;
  final String address;
  final String rating;
  final String photoReference;

  Hotel({
    required this.name,
    required this.address,
    required this.rating,
    required this.photoReference,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = 'AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM'; // Replace with your API key
  List<Destination> destinations = [];
  List<Hotel> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSriLankanDestinations();
    fetchSriLankanHotels();
  }

  Future<void> fetchSriLankanDestinations() async {
    // Predefined list of popular Sri Lankan destinations
    final List<Map<String, dynamic>> sriLankanDestinations = [
      {
        'name': 'Mirissa',
        'location': 'Down South',
        'placeId': 'ChIJofFwPGP15ToRNGdm1BkdXMc',
      },
      {
        'name': 'Sigiriya',
        'location': 'North-Central Province',
        'placeId': 'ChIJNc5l5ka-4ToR6Dqh7XadRCw',
      },
      {
        'name': 'Arugam Bay',
        'location': 'Eastern Province',
        'placeId': 'ChIJhQ9NCTOa4zoR9OSPvGKV1Yk',
      },
      {
        'name': 'Ella',
        'location': 'Uva Province',
        'placeId': 'ChIJ4Vx6NOmG5ToRJzgpC8tU9UU',
      },
      {
        'name': 'Kandy',
        'location': 'Central Province',
        'placeId': 'ChIJB7NkBj6V4ToRPp_tXsQRtlM',
      },
    ];

    List<Destination> tempDestinations = [];

    for (var destination in sriLankanDestinations) {
      try {
        final response = await http.get(
          Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=${destination['placeId']}&fields=name,photos,rating&key=$apiKey'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            final result = data['result'];
            String photoReference = '';

            if (result.containsKey('photos') && result['photos'].isNotEmpty) {
              photoReference = result['photos'][0]['photo_reference'];
            }

            tempDestinations.add(Destination(
              name: destination['name'],
              location: destination['location'],
              rating: (result['rating'] ?? '4.5').toString(),
              price: '\$${(150 + (tempDestinations.length * 50))}/pax',
              photoReference: photoReference,
            ));
          }
        }
      } catch (e) {
        print('Error fetching destination: $e');
      }
    }

    // If API calls failed, use default destinations
    if (tempDestinations.isEmpty) {
      tempDestinations = [
        Destination(
          name: 'Mirissa',
          location: 'Down South',
          rating: '4.9',
          price: '\$ 150/pax',
          photoReference: '',
        ),
        Destination(
          name: 'Sigiriya',
          location: 'North-Central Province',
          rating: '4.8',
          price: '\$ 250/pax',
          photoReference: '',
        ),
        Destination(
          name: 'Arugam Bay',
          location: 'Eastern Province',
          rating: '4.8',
          price: '\$ 200/pax',
          photoReference: '',
        ),
        Destination(
          name: 'Ella',
          location: 'Uva Province',
          rating: '5.0',
          price: '\$ 250/pax',
          photoReference: '',
        ),
        Destination(
          name: 'Kandy',
          location: 'Central Province',
          rating: '4.8',
          price: '\$ 200/pax',
          photoReference: '',
        ),
      ];
    }

    if (mounted) {
      setState(() {
        destinations = tempDestinations;
      });
    }
  }


  Future<void> fetchSriLankanHotels() async {
    try {
      // Using textual search for hotels in Colombo
      final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=top+hotels+in+colombo+sri+lanka&type=lodging&key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          List<Hotel> tempHotels = [];

          for (var result in data['results'].take(5)) {
            String photoReference = '';

            if (result.containsKey('photos') && result['photos'].isNotEmpty) {
              photoReference = result['photos'][0]['photo_reference'];
            }

            tempHotels.add(Hotel(
              name: result['name'],
              address: result['formatted_address'],
              rating: '${result['rating'] ?? '5'}-star hotel',
              photoReference: photoReference,
            ));
          }

          if (mounted) {
            setState(() {
              hotels = tempHotels;
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching hotels: $e');
      // Fallback to default hotels if API call fails
      if (mounted) {
        setState(() {
          hotels = [
            Hotel(
              name: 'Shangri-La Colombo',
              address: 'No.101, Ward Place, Colombo 7',
              rating: '5-star hotel',
              photoReference: '',
            ),
            Hotel(
              name: 'Cinnamon Grand Colombo',
              address: '77 Galle Road, Colombo 3',
              rating: '5-star hotel',
              photoReference: '',
            ),
          ];
          isLoading = false;
        });
      }
    }
  }

  String getPhotoUrl(String photoReference) {
    if (photoReference.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
  }

  Widget _buildHotelCard(
      String name,
      String address,
      String rating,
      String imageUrl,
      ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.hotel, color: Colors.grey[500]),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2C6E49),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Book',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08746C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting and profile
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi, Heshan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.circle,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '2,000 points',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Icon(Icons.person, size: 24, color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ),

            // Main content with white background
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Where to go?',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),

                      ),
                    ),

                    // Upcoming flight card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2C6E49),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'Upcoming',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '18 May 2025',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'COL',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '05:30',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.flight_takeoff, size: 20),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                  height: 1,
                                                  child: CustomPaint(
                                                    painter: DashedLinePainter(),
                                                    size: const Size(double.infinity, 1),
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.flight_land, size: 20),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            '11h 30m',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: const [
                                        Text(
                                          'UAE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '06:30',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      child: Text(
                                        'SriLankan Airline',
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(' • ', style: TextStyle(fontSize: 12)),
                                    Flexible(
                                      child: Text(
                                        'Economy',
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(' • ', style: TextStyle(fontSize: 12)),
                                    Flexible(
                                      child: Text(
                                        'Direct',
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Booking ID',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Details',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF08746C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    // Category icons
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCategoryIcon(Icons.flight, 'Flights', const Color(0xFFB2D8D8)),
                          _buildCategoryIcon(Icons.hotel, 'Hotels', const Color(0xFFB2D8D8)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmergencyScreen()),
                              );
                            },
                            child: _buildCategoryIcon(Icons.warning, 'Emergency', const Color(0xFFB2D8D8)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContactsScreen()),
                              );
                            },
                            child: _buildCategoryIcon(Icons.person_outline, 'Contacts', const Color(0xFFB2D8D8)),


                          ),
                          _buildCategoryIcon(Icons.directions_bus, 'Bus', const Color(0xFFB2D8D8)),
                        ],
                      ),
                    ),

                    // Journey Points section
                    // Your original padding widget modified with navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Journey Points',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the TravelHomePage when tapped
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const TravelHomePage(),
                                ),
                              );
                            },
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF08746C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Journey Points cards
                    SizedBox(
                      height: 250,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinations[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: _buildDestinationCard(
                              destination.name,
                              destination.location,
                              destination.rating,
                              destination.price,
                              getPhotoUrl(destination.photoReference),
                            ),
                          );
                        },
                      ),
                    ),

                    // Hotel recommendations
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hotels recommendation for you',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the TravelHomePage when tapped
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HotelListScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF08746C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    // Hotel cards
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                      children: hotels.map((hotel) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 15,
                          ),
                          child: _buildHotelCard(
                            hotel.name,
                            hotel.address,
                            hotel.rating,
                            getPhotoUrl(hotel.photoReference),
                          ),
                        );
                      }).toList(),
                    ),

                    // Adjusted bottom padding to prevent overflow
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true, // Make the body extend behind the bottom navigation bar
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home', true),


            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: _buildNavItem(Icons.map, 'map', false),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TranslationScreen()),
                );
              },
              child: _buildCircularNavItem(Icons.translate),
            ),
            _buildNavItem(Icons.hotel, 'Hotels', false),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrencyConverterScreen()),
                );
              },
              child: _buildNavItem(Icons.currency_exchange, 'Currency', false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Minimize vertical space
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF08746C),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(
      String name,
      String location,
      String rating,
      String price,
      String imageUrl,
      ) {
    return Container(
      width: 160,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  width: 160,
                  color: Colors.grey[300],
                  child: Icon(Icons.landscape, size: 40, color: Colors.grey[500]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(

                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start from',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C6E49),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'visit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Minimize vertical space
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF08746C) : Colors.black87,
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFF08746C) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularNavItem(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF66B2B2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Icon(
        Icons.translate,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

