import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard.dart';

class AddNewAdmin extends StatefulWidget {
  const AddNewAdmin({super.key});

  @override
  AddNewAdminState createState() => AddNewAdminState();
}

class AddNewAdminState extends State<AddNewAdmin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _adminDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminUsers();
  }

  // Load Admin users
  Future<void> _loadAdminUsers() async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await _firestore.collection('Admin').get();
      setState(() {
        _adminDocs = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading admins: ${e.toString()}')),
      );
      setState(() => _isLoading = false);
    }
  }

  // Add new Admin user
  Future<void> _addAdminDialog() async {
    final TextEditingController idController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Admin User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Username (id)'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final id = idController.text.trim();
              final password = passwordController.text.trim();

              if (id.isNotEmpty && password.isNotEmpty) {
                await _firestore.collection('Admin').add({
                  'id': id,
                  'password': password,
                });
                Navigator.pop(context);
                _loadAdminUsers();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Password verification dialog
  Future<bool> _verifyPassword(String correctPassword) async {
    final TextEditingController passwordController = TextEditingController();
    bool verified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.trim() == correctPassword) {
                verified = true;
              }
              Navigator.pop(context);
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );

    return verified;
  }

  // Update Admin user
  Future<void> _updateAdminDialog(QueryDocumentSnapshot doc) async {
    final admin = doc.data() as Map<String, dynamic>;
    bool isVerified = await _verifyPassword(admin['password']);

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password verification failed')),
      );
      return;
    }

    final TextEditingController idController = TextEditingController(
      text: admin['id'],
    );
    final TextEditingController passwordController = TextEditingController(
      text: admin['password'],
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Admin User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Username (id)'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final id = idController.text.trim();
              final password = passwordController.text.trim();

              if (id.isNotEmpty && password.isNotEmpty) {
                await _firestore.collection('Admin').doc(doc.id).update({
                  'id': id,
                  'password': password,
                });
                Navigator.pop(context);
                _loadAdminUsers();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Delete Admin user
  Future<void> _deleteAdmin(QueryDocumentSnapshot doc) async {
    final admin = doc.data() as Map<String, dynamic>;
    bool isVerified = await _verifyPassword(admin['password']);

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password verification failed')),
      );
      return;
    }

    await _firestore.collection('Admin').doc(doc.id).delete();
    _loadAdminUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin User Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAdminDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        tooltip: 'Add Admin User',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAdminUsers,
              child: ListView.builder(
                itemCount: _adminDocs.length,
                itemBuilder: (context, index) {
                  final doc = _adminDocs[index];
                  final admin = doc.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text("ID: ${admin['id'] ?? 'No ID'}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteAdmin(doc),
                    ),
                    onLongPress: () => _updateAdminDialog(doc),
                  );
                },
              ),
            ),
    );
  }
}
