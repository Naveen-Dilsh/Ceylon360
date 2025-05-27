import 'package:flutter/material.dart';

class ContactSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> contacts;
  final Function(String number, String name, String category) makePhoneCall;
  final IconData Function(String category) getCategoryIcon;
  final Color Function(String category) getCategoryColor;

  ContactSearchDelegate({
    required this.contacts,
    required this.makePhoneCall,
    required this.getCategoryIcon,
    required this.getCategoryColor,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = contacts.where((contact) {
      return contact['name'].toLowerCase().contains(query.toLowerCase()) ||
          contact['number'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildResultList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = contacts.where((contact) {
      return contact['name'].toLowerCase().contains(query.toLowerCase()) ||
          contact['number'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildResultList(suggestions);
  }

  Widget _buildResultList(List<Map<String, dynamic>> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final contact = results[index];
        return ListTile(
          leading: Icon(getCategoryIcon(contact['category']), color: getCategoryColor(contact['category'])),
          title: Text(contact['name']),
          subtitle: Text(contact['number']),
          trailing: IconButton(
            icon: Icon(Icons.call),
            onPressed: () => makePhoneCall(contact['number'], contact['name'], contact['category']),
          ),
        );
      },
    );
  }
}
