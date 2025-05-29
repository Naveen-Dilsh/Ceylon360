import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sos_emergency_screen.dart';
import 'contact_search_delegate.dart';
import 'add_contact_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Map<String, dynamic>> _contacts = [
    {'name': 'Mom', 'number': '+94712345678', 'category': 'personal', 'isPinned': true},
    {'name': 'Dad', 'number': '+94723456789', 'category': 'personal', 'isPinned': false},
    {'name': 'Emergency Services', 'number': '119', 'category': 'emergency', 'isPinned': true},
    {'name': 'Police Department', 'number': '0711824885', 'category': 'emergency', 'isPinned': true},
    {'name': 'Local Hospital', 'number': '1990', 'category': 'medical', 'isPinned': false},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String _selectedCategory = 'personal';
  bool _isAddingContact = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Personal', 'value': 'personal', 'icon': Icons.person, 'color': Colors.blue},
    {'name': 'Medical', 'value': 'medical', 'icon': Icons.medical_services, 'color': Colors.green},
    {'name': 'Emergency', 'value': 'emergency', 'icon': Icons.emergency, 'color': Colors.red},
    {'name': 'Work', 'value': 'work', 'icon': Icons.work, 'color': Colors.orange},
  ];

  Future<void> _makePhoneCall(String phoneNumber, String name, String category) async {
    bool isEmergencyNumber = phoneNumber == '119' || phoneNumber == '911' || phoneNumber == '1990';

    if (category == 'emergency' || isEmergencyNumber) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SOSEmergencyScreen(
            contactNumber: phoneNumber,
            contactName: name,
          ),
        ),
      );
    } else {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      await launchUrl(launchUri);
    }
  }

  void _addContact() {
    if (_nameController.text.isNotEmpty && _numberController.text.isNotEmpty) {
      setState(() {
        _contacts.add({
          'name': _nameController.text,
          'number': _numberController.text,
          'category': _selectedCategory,
          'isPinned': false,
        });
        _isAddingContact = false;
      });
      _nameController.clear();
      _numberController.clear();
      _selectedCategory = 'personal';
    }
  }

  void _togglePinContact(int index) {
    setState(() {
      _contacts[index]['isPinned'] = !_contacts[index]['isPinned'];
      _contacts.sort((a, b) {
        if (a['isPinned'] && !b['isPinned']) return -1;
        if (!a['isPinned'] && b['isPinned']) return 1;
        return 0;
      });
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  Color _getCategoryColor(String category) {
    final categoryItem = _categories.firstWhere(
          (item) => item['value'] == category,
      orElse: () => _categories[0],
    );
    return categoryItem['color'];
  }

  IconData _getCategoryIcon(String category) {
    final categoryItem = _categories.firstWhere(
          (item) => item['value'] == category,
      orElse: () => _categories[0],
    );
    return categoryItem['icon'];
  }

  Map<String, List<Map<String, dynamic>>> get groupedContacts {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var contact in _filteredContacts) {
      final category = contact['category'];
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(contact);
    }
    return grouped;
  }

  List<Map<String, dynamic>> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;
    return _contacts.where((contact) {
      return contact['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact['number'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Important Contacts'),
        backgroundColor: const Color(0xFF08746C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(
                  contacts: _contacts,
                  makePhoneCall: _makePhoneCall,
                  getCategoryIcon: _getCategoryIcon,
                  getCategoryColor: _getCategoryColor,
                ),
              );
            },
          ),
        ],
      ),
      body: _isAddingContact ? _buildAddContactForm() : _buildContactsList(),
      floatingActionButton: !_isAddingContact
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddingContact = true;
          });
        },
        backgroundColor: const Color(0xFF08746C),
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  Widget _buildContactsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var category in groupedContacts.keys) ...[
            Text(
              _categories.firstWhere((c) => c['value'] == category)['name'] + ' Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _getCategoryColor(category),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedContacts[category]!.length,
              itemBuilder: (context, index) {
                final contact = groupedContacts[category]![index];
                return _buildContactTile(contact: contact, index: _contacts.indexOf(contact));
              },
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildContactTile({required Map<String, dynamic> contact, required int index}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor(contact['category']).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: _getCategoryColor(contact['category']), width: 2),
          ),
          child: Icon(_getCategoryIcon(contact['category']), color: _getCategoryColor(contact['category'])),
        ),
        title: Text(contact['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    contact['number'],
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (contact['isPinned'])
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF08746C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.star, size: 12, color: Color(0xFF08746C)),
                    SizedBox(width: 2),
                    Text('Pinned',
                        style: TextStyle(fontSize: 10, color: Color(0xFF08746C), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
        // Fixed: Now using a Row with MainAxisAlignment and properly sized IconButtons
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                contact['isPinned'] ? Icons.star : Icons.star_border,
                color: contact['isPinned'] ? Colors.amber : Colors.grey,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
              onPressed: () => _togglePinContact(index),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.call, color: Color(0xFF08746C), size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
              onPressed: () => _makePhoneCall(contact['number'], contact['name'], contact['category']),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[300], size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
              onPressed: () => _deleteContact(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddContactForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Contact',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF08746C),
            ),
          ),
          const SizedBox(height: 25),

          // Name Field
          Material(
            elevation: 3,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Color(0xFF08746C)),
                labelText: 'Full Name',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Phone Number Field
          Material(
            elevation: 3,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF08746C)),
                labelText: 'Phone Number',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Category Dropdown
          Material(
            elevation: 3,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              icon: const Icon(Icons.arrow_drop_down),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.category, color: Color(0xFF08746C)),
                labelText: 'Select Category',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _categories
                  .map((category) => DropdownMenuItem<String>(
                value: category['value'],
                child: Text(category['name']),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 30),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addContact,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08746C),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isAddingContact = false;
                    });
                  },
                  icon: const Icon(Icons.cancel, color: Color(0xFF08746C)),
                  label: const Text('Cancel', style: TextStyle(color: Color(0xFF08746C))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF08746C)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}