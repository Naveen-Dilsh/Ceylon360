import 'package:flutter/material.dart';

class EmergencyType {
  final String type;
  final IconData icon;
  final Color color;

  EmergencyType({
    required this.type,
    required this.icon,
    required this.color,
  });
}

class EmergencyContact {
  final IconData icon;
  final String title;
  final String number;

  EmergencyContact({
    required this.icon,
    required this.title,
    required this.number,
  });
}

// List of emergency types
final List<EmergencyType> emergencyTypes = [
  EmergencyType(type: 'FIRE', icon: Icons.local_fire_department, color: Colors.red.shade700),
  EmergencyType(type: 'FLOOD', icon: Icons.water, color: Colors.blue.shade700),
  EmergencyType(type: 'CRIME', icon: Icons.gavel, color: Colors.purple.shade700),
  EmergencyType(type: 'ACCIDENT', icon: Icons.car_crash, color: Colors.orange.shade700),
  EmergencyType(type: 'EARTHQUAKE', icon: Icons.house_outlined, color: Colors.amber.shade700),
  EmergencyType(type: 'MEDICAL', icon: Icons.medical_services, color: Colors.green.shade700),
];

// List of emergency contacts
final List<EmergencyContact> emergencyContacts = [
  EmergencyContact(icon: Icons.local_police, title: 'Police', number: '118'),
  EmergencyContact(icon: Icons.local_hospital, title: 'Ambulance', number: '1990'),
  EmergencyContact(icon: Icons.fire_truck, title: 'Fire Department', number: '110'),
  EmergencyContact(icon: Icons.support_agent, title: 'Disaster Management', number: '117'),
];