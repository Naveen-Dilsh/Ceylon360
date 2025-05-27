import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailSendDetails extends StatefulWidget {
  const EmailSendDetails({super.key});

  @override
  State<EmailSendDetails> createState() => _EmailSendDetailsState();
}

class _EmailSendDetailsState extends State<EmailSendDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Email Send Details")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('EmailLogs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading email logs'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final emailDocs = snapshot.data?.docs ?? [];

          if (emailDocs.isEmpty) {
            return const Center(child: Text('No emails found'));
          }

          return ListView.builder(
            itemCount: emailDocs.length,
            itemBuilder: (context, index) {
              final doc = emailDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              final to = data['to'] ?? 'Unknown';
              final from = data['from'] ?? 'Unknown';
              final subject = data['subject'] ?? 'No subject';
              final preview = data['messagePreview'] ?? '';
              final status = data['status'] ?? 'unknown';
              final timestamp = data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : null;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    status == 'sent' ? Icons.check_circle : Icons.error,
                    color: status == 'sent' ? Colors.green : Colors.red,
                  ),
                  title: Text(subject),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To: $to'),
                      Text('From: $from'),
                      Text('Status: $status'),
                      if (timestamp != null)
                        Text(
                          'Time: ${timestamp.toLocal()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Email Preview'),
                          content: Text(preview),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
