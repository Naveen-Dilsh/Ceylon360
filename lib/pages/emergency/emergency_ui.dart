import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'emergency_models.dart';

class EmergencyUIHelper {
  Widget buildEmergencyTypeSection({
    required String selectedEmergency,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Emergency Type', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: emergencyTypes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final item = emergencyTypes[index];
            final isSelected = item.type == selectedEmergency;
            return GestureDetector(
              onTap: () => onSelect(item.type),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? item.color.withOpacity(0.2) : Colors.white,
                  border: Border.all(color: isSelected ? item.color : Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: item.color),
                    const SizedBox(height: 8),
                    Text(item.type),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildLocationSection({
    required bool isLoadingLocation,
    required LatLng? currentLocation,
    required Function(GoogleMapController) onMapCreated,
    required VoidCallback onRefreshLocation,
    required VoidCallback onTryAgain,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: onRefreshLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Refresh Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF08746C),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoadingLocation
              ? const Center(child: CircularProgressIndicator())
              : currentLocation == null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                const Text('Location not available'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onTryAgain,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: currentLocation, zoom: 15),
              markers: {
                Marker(markerId: const MarkerId('loc'), position: currentLocation),
              },
              onMapCreated: onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
            ),
          ),
        ),
        if (currentLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Lat: ${currentLocation.latitude.toStringAsFixed(6)}, Lng: ${currentLocation.longitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget buildDescriptionSection(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Emergency Details', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Describe the emergency situation in detail...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget buildPersonalInfoSection(
      TextEditingController nameController,
      TextEditingController phoneController,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Your Information (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Your Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
      ],
    );
  }

  Widget buildSendReportButton({
    required bool isSendingReport,
    required VoidCallback onSendReport,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ElevatedButton.icon(
        onPressed: isSendingReport ? null : onSendReport,
        icon: isSendingReport
            ? Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(2.0),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : const Icon(Icons.send),
        label: Text(
          isSendingReport ? 'Sending Report...' : 'Send Emergency Report',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildEmergencyContactsSection({
    required Function(String) onMakeCall,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Emergency Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...emergencyContacts.map((contact) => buildContactTile(
          icon: contact.icon,
          title: contact.title,
          number: contact.number,
          onCall: () => onMakeCall(contact.number),
        )),
      ],
    );
  }

  Widget buildContactTile({
    required IconData icon,
    required String title,
    required String number,
    required VoidCallback onCall,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF08746C), size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Call $number'),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: onCall,
        ),
      ),
    );
  }
}