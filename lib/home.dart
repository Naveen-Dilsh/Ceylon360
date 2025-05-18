import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/hotels/hotel_list_screen.dart';


import 'data/repositories/authentication/authentication_repository.dart';
import 'features/authentication/screens/login/login.dart';
import 'features/personalization/screens/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<NatureSpot> popularSpots = [
    NatureSpot(
      name: "Sigiriya",
      description: "Ancient rock fortress with panoramic views",
      imageUrl: "",
    ),
    NatureSpot(
      name: "Ella",
      description: "Mountain village with stunning valleys and waterfalls",
      imageUrl: "assets/images/ella.jpg",
    ),
    NatureSpot(
      name: "Yala National Park",
      description: "Home to leopards, elephants and incredible wildlife",
      imageUrl: "assets/images/yala.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sri Lanka Nature Explorer',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              try {
                await AuthenticationRepository.instance.logout();
                Get.offAll(() => const LoginScreen());
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/sri_lanka_banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discover Sri Lanka",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Experience the beauty of the pearl of the Indian Ocean",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Special promo section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "50% OFF",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "On all guided nature tours this month",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade900,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const ProfileScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Book Now"),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Popular destinations section
                  Text(
                    "Popular Nature Spots",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 16),

                  // Nature spots list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: popularSpots.length,
                    itemBuilder: (context, index) {
                      return NatureSpotCard(spot: popularSpots[index]);
                    },
                  ),

                  SizedBox(height: 24),

                  // Explore more button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // For development purposes
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Full catalog coming soon!')),
                        );
                      },
                      icon: Icon(Icons.explore),
                      label: Text("Explore More Destinations"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model for nature spots
class NatureSpot {
  final String name;
  final String description;
  final String imageUrl;

  NatureSpot({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

// Widget for displaying nature spots
class NatureSpotCard extends StatelessWidget {
  final NatureSpot spot;

  const NatureSpotCard({Key? key, required this.spot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: AssetImage(spot.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spot.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  spot.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating indicator
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Icon(Icons.star_half, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "4.5",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Learn more button
                    TextButton.icon(
                      onPressed: () {
                        // For development purposes
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Details page coming soon!')),
                        );
                      },
                      icon: Icon(Icons.arrow_forward, size: 16),
                      label: Text("Learn more"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green.shade800,
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
}
