import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendSMSDetails extends StatelessWidget {
  const SendSMSDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sent SMS Logs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('SMSLogs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No SMS logs found.'));
          }

          final smsLogs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: smsLogs.length,
            itemBuilder: (context, index) {
              final log = smsLogs[index].data() as Map<String, dynamic>;
              final timestamp = (log['timestamp'] as Timestamp?)?.toDate();
              final phone = log['phone'] ?? 'N/A';
              final carrier = log['carrier'] ?? 'N/A';
              final message = log['message'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.sms, color: Colors.blue),
                  title: Text('To: $phone ($carrier)'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Message: $message'),
                      if (timestamp != null)
                        Text(
                          'Time: ${timestamp.toLocal()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
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
