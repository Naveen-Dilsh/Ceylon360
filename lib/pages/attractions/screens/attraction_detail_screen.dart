import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttractionDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String? photoUrl;
  final double lat;
  final double lng;

  const AttractionDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.lat,
    required this.lng,
  });

  void launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=My+Location&destination=$lat,$lng&travelmode=driving';

    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Maps';
      }
    } catch (e) {
      print('Error launching maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  photoUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Divider(),
            const SizedBox(height: 8),
            Text(
              'About this place',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  final mapUrl =
                      'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                  launchUrl(
                    Uri.parse(mapUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: Icon(Icons.directions),
                label: Text('Get Directions'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
