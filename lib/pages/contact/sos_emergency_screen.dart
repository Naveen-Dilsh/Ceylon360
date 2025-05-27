import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSEmergencyScreen extends StatelessWidget {
  final String contactNumber;
  final String contactName;

  const SOSEmergencyScreen({
    Key? key,
    required this.contactNumber,
    required this.contactName,
  }) : super(key: key);

  Future<void> _callEmergencyNumber() async {
    final Uri launchUri = Uri(scheme: 'tel', path: contactNumber);
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text('SOS Emergency Call'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: Colors.red, size: 80),
              SizedBox(height: 20),
              Text(
                'Are you sure you want to call $contactName?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: Icon(Icons.call),
                label: Text('Call Now'),
                onPressed: _callEmergencyNumber,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
