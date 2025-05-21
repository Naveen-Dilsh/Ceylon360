import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EmergencyServices {
  final String _mapsApiKey = 'AIzaSyDPPGBYGwYTOrWtL9dNmiXkjhrsGS6sFTY'; // Replace with your real API key
  LatLng? currentLocation;
  GoogleMapController? _mapController;
  final Location _locationService = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> makePhoneCall(String phoneNumber, Function(String) onError) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(launchUri);
    } catch (e) {
      onError('Could not launch phone call: $e');
    }
  }

  // Initialize location service with proper error handling
  Future<void> initLocationService({
    required Function(String) onError,
    required VoidCallback onLocationChange,
  }) async {
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          onError('Location services are disabled');
          return;
        }
      }

      await _requestLocationPermission(onError);
      await getCurrentLocation(onError: onError, onLocationChange: onLocationChange);
      _startLocationUpdates(onError, onLocationChange);
    } catch (e) {
      onError('Error initializing location: $e');
    }
  }

  // Start listening to location updates
  void _startLocationUpdates(Function(String) onError, VoidCallback onLocationChange) {
    try {
      _locationService.changeSettings(interval: 10000); // Update every 10 seconds
      _locationSubscription = _locationService.onLocationChanged.listen((LocationData locationData) {
        if (locationData.latitude != null && locationData.longitude != null) {
          currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
          onLocationChange();
        }
      });
    } catch (e) {
      onError('Error starting location updates: $e');
    }
  }

  Future<void> getCurrentLocation({
    required Function(String) onError,
    required VoidCallback onLocationChange,
  }) async {
    try {
      final hasPermission = await _requestLocationPermission(onError);
      if (!hasPermission) {
        onError('Location permission denied');
        return;
      }

      final locationData = await _locationService.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        onLocationChange();
      } else {
        onError('Could not get location coordinates');
      }
    } catch (e) {
      print('Error getting location: $e');
      onError('Error getting location: $e');
    }
  }

  Future<bool> _requestLocationPermission(Function(String) onError) async {
    try {
      PermissionStatus permission = await _locationService.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _locationService.requestPermission();
      }
      return permission == PermissionStatus.granted;
    } catch (e) {
      onError('Error requesting location permission: $e');
      return false;
    }
  }

  void updateCameraPosition() {
    if (_mapController != null && currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation!, zoom: 15),
        ),
      );
    }
  }
}