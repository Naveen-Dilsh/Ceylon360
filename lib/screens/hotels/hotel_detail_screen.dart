import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/hotel_model.dart';
import '../../services/hotel_places_service.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({Key? key, required this.hotel}) : super(key: key);

  void _openInGoogleMaps(double lat, double lng) {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _openWebsite(BuildContext context) async {
    try {
      final website = await PlacesService().getHotelWebsite(hotel.placeId);
      if (website.isNotEmpty) {
        launchUrl(Uri.parse(website), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No website available')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching website: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = PlacesService.getPhotoUrl(hotel.photoReference);

    return Scaffold(
      appBar: AppBar(title: Text(hotel.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ Show photo
          if (photoUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photoUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
            ),
          const SizedBox(height: 16),

          // ✅ Hotel name and address
          Text(hotel.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(hotel.address),
          const SizedBox(height: 12),

          // ✅ Star rating
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(hotel.rating.toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Mock description
          Text(
            "Experience the comfort and hospitality of ${hotel.name}, conveniently located in ${hotel.address}. Ideal for travelers seeking relaxation and city access.",
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 24),

          // ✅ Buttons
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade50,
              foregroundColor: Colors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => _openInGoogleMaps(hotel.lat, hotel.lng),
            icon: const Icon(Icons.map),
            label: const Text("Get Directions"),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade50,
              foregroundColor: Colors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => _openWebsite(context),
            icon: const Icon(Icons.link),
            label: const Text("Visit Website"),
          ),
        ],
      ),
    );
  }
}