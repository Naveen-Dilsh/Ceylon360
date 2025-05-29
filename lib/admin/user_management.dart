import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  UserManagementState createState() => UserManagementState();
}

class UserManagementState extends State<UserManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _userDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load regular users
  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await _firestore.collection('Users').get();
      setState(() {
        _userDocs = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: ${e.toString()}')),
      );
      setState(() => _isLoading = false);
    }
  }

  // Delete user account
  Future<void> _deleteUser(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: ${e.toString()}')),
      );
    }
  }

  // Show user data in dialog
  void _showUserDataDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exported User Data'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: userData.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                itemCount: _userDocs.length,
                itemBuilder: (context, index) {
                  final user = _userDocs[index].data() as Map<String, dynamic>;
                  final doc = _userDocs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ${user['name'] ?? 'No Name'}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Email: ${user['email'] ?? 'No Email'}"),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.download),
                                label: const Text('Export Data'),
                                onPressed: () => _showUserDataDialog({
                                  'userId': doc.id,
                                  ...user,
                                }),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete Account'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => _deleteUser(doc.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
