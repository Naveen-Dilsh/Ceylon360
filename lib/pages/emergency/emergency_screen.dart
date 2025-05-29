import 'package:flutter/material.dart';
import 'emergency_models.dart';
import 'emergency_ui.dart';
import 'emergency_services.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final EmergencyUIHelper _uiHelper = EmergencyUIHelper();
  final EmergencyServices _services = EmergencyServices();

  String _selectedEmergency = '';
  bool _isLoadingLocation = false;
  bool _isSendingReport = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _services.initLocationService(
      onError: _showErrorSnackBar,
      onLocationChange: _onLocationChanged,
    );
  }

  void _onLocationChanged() {
    setState(() {});
    _services.updateCameraPosition();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _services.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    await _services.getCurrentLocation(
      onError: _showErrorSnackBar,
      onLocationChange: _onLocationChanged,
    );

    setState(() => _isLoadingLocation = false);
  }

  Future<void> _sendEmergencyReport() async {
    // Validate input
    if (_selectedEmergency.isEmpty) {
      _showErrorSnackBar('Please select an emergency type');
      return;
    }

    if (_services.currentLocation == null) {
      _showErrorSnackBar('Location data is not available');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar('Please describe the emergency');
      return;
    }

    try {
      setState(() => _isSendingReport = true);

      // Simulate sending report to a server
      await Future.delayed(const Duration(seconds: 2));

      // Show success dialog
      if (mounted) {
        setState(() => _isSendingReport = false);
        _showReportSuccessDialog();
      }
    } catch (e) {
      setState(() => _isSendingReport = false);
      _showErrorSnackBar('Failed to send report: $e');
    }
  }

  void _showReportSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Sent'),
        content: const Text(
          'Your emergency report has been sent successfully. Emergency services have been notified.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset the form
              setState(() {
                _selectedEmergency = '';
                _descriptionController.clear();
                _nameController.clear();
                _phoneController.clear();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        backgroundColor: const Color(0xFF08746C),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_enabled),
            onPressed: () => _services.makePhoneCall('119', _showErrorSnackBar),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () => _services.makePhoneCall('119', _showErrorSnackBar),
              icon: const Icon(Icons.emergency, size: 30),
              label: const Text('SOS - Call 119', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _uiHelper.buildEmergencyTypeSection(
                      selectedEmergency: _selectedEmergency,
                      onSelect: (type) => setState(() => _selectedEmergency = type),
                    ),
                    _uiHelper.buildLocationSection(
                      isLoadingLocation: _isLoadingLocation,
                      currentLocation: _services.currentLocation,
                      onMapCreated: _services.onMapCreated,
                      onRefreshLocation: _getCurrentLocation,
                      onTryAgain: () => _services.initLocationService(
                        onError: _showErrorSnackBar,
                        onLocationChange: _onLocationChanged,
                      ),
                    ),
                    _uiHelper.buildDescriptionSection(_descriptionController),
                    _uiHelper.buildPersonalInfoSection(_nameController, _phoneController),
                    _uiHelper.buildSendReportButton(
                      isSendingReport: _isSendingReport,
                      onSendReport: _sendEmergencyReport,
                    ),
                    _uiHelper.buildEmergencyContactsSection(
                      onMakeCall: (number) => _services.makePhoneCall(number, _showErrorSnackBar),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}