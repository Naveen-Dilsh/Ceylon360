import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleApiManager extends StatefulWidget {
  @override
  GoogleApiManagerState createState() => GoogleApiManagerState();
}

class GoogleApiManagerState extends State<GoogleApiManager> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Add new API
  Future<void> _addApiLink() async {
    if (_titleController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Title and URL are required')));
      return;
    }

    await FirebaseFirestore.instance.collection('google_apis').add({
      'title': _titleController.text.trim(),
      'url': _urlController.text.trim(),
      'description': _descriptionController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    _titleController.clear();
    _urlController.clear();
    _descriptionController.clear();
  }

  // Update existing API
  Future<void> _updateApiLink(DocumentSnapshot doc) async {
    final TextEditingController updateTitleController = TextEditingController(
      text: doc['title'],
    );
    final TextEditingController updateUrlController = TextEditingController(
      text: doc['url'],
    );
    final TextEditingController updateDescController = TextEditingController(
      text: doc['description'],
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Update API"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: updateTitleController,
              decoration: InputDecoration(labelText: 'API Title'),
            ),
            TextField(
              controller: updateUrlController,
              decoration: InputDecoration(labelText: 'API URL'),
            ),
            TextField(
              controller: updateDescController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Update"),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('google_apis')
                  .doc(doc.id)
                  .update({
                'title': updateTitleController.text.trim(),
                'url': updateUrlController.text.trim(),
                'description': updateDescController.text.trim(),
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Delete API
  Future<void> _deleteApiLink(String id) async {
    await FirebaseFirestore.instance.collection('google_apis').doc(id).delete();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('API deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google API Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add API Form
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'API Title'),
            ),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'API URL'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: _addApiLink, child: Text('Add API Link')),
            SizedBox(height: 20),

            // API List from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('google_apis')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return Text('No API links added yet.');
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final doc = docs[index];

                      return Card(
                        child: ListTile(
                          title: Text(data['title'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['url'] ?? ''),
                              if ((data['description'] ?? '').isNotEmpty)
                                Text(
                                  data['description'] ?? '',
                                  style: TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _updateApiLink(doc),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteApiLink(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
