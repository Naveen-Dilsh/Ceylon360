import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SMSManagement extends StatefulWidget {
  const SMSManagement({super.key});

  @override
  State<SMSManagement> createState() => _SMSManagementState();
}

class _SMSManagementState extends State<SMSManagement> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  final List<String> _carriers = ['Verizon', 'AT&T', 'T-Mobile'];
  String? _selectedCarrier;

  late SmtpServer smtpServer;

  @override
  void initState() {
    super.initState();
  }

  String? _getCarrierEmail(String carrier, String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    switch (carrier.toLowerCase()) {
      case 'verizon':
        return "$cleaned@vtext.com";
      case 'at&t':
      case 'att':
        return "$cleaned@txt.att.net";
      case 't-mobile':
      case 'tmobile':
        return "$cleaned@tmomail.net";
      default:
        return null;
    }
  }

  Future<void> sendSMSViaGmail() async {
    final phone = _phoneController.text.trim();
    final carrier = _selectedCarrier ?? '';
    final body = _messageController.text.trim();

    final smsEmail = _getCarrierEmail(carrier, phone);

    if (smsEmail == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unsupported carrier')));
      return;
    }

    final message = Message()
      ..from = Address('SMS Bot')
      ..recipients.add(smsEmail)
      ..subject = ''
      ..text = body;

    try {
      await send(message, smtpServer);

      // Store SMS log in Firestore
      await FirebaseFirestore.instance.collection('SMSLogs').add({
        'phone': phone,
        'carrier': carrier,
        'message': body,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SMS sent and logged successfully')),
      );

      _phoneController.clear();
      _messageController.clear();
      setState(() {
        _selectedCarrier = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send SMS: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Email-to-SMS")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Enter phone number' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Carrier'),
                value: _selectedCarrier,
                items: _carriers
                    .map(
                      (carrier) => DropdownMenuItem(
                        value: carrier,
                        child: Text(carrier),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCarrier = value),
                validator: (value) => value == null || value.isEmpty ? 'Select a carrier' : null,
              ),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Send SMS via Gmail'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendSMSViaGmail();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
