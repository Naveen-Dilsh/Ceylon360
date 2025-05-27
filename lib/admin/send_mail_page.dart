import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMailPage extends StatefulWidget {
  const SendMailPage({super.key});

  @override
  State<SendMailPage> createState() => _SendMailPageState();
}

class _SendMailPageState extends State<SendMailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  late SmtpServer gmailSmtp;

  @override
  void initState() {
    super.initState();
    gmailSmtp = gmail(
      dotenv.env["GMAIL_EMAIL"]!,
      dotenv.env["GMAIL_PASSWORD"]!,
    );
  }

  Future<void> sendMailFromGmail() async {
    final prefs = await SharedPreferences.getInstance();
    final adminId = prefs.getString('admin_id') ?? 'unknown';

    final recipient = _recipientController.text.trim();
    final subject = _subjectController.text.trim();
    final body = _bodyController.text.trim();

    final message = Message()
      ..from = Address(dotenv.env["GMAIL_EMAIL"]!, 'Confirmation Bot')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, gmailSmtp);
      print('Message sent: $sendReport');

      await FirebaseFirestore.instance.collection('EmailLogs').add({
        'to': recipient,
        'from': dotenv.env["GMAIL_EMAIL"],
        'subject': subject,
        'messagePreview':
            body.length > 100 ? '${body.substring(0, 100)}...' : body,
        'status': 'sent',
        'timestamp': FieldValue.serverTimestamp(),
        'sentBy': adminId,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email sent successfully!')));

      _recipientController.clear();
      _subjectController.clear();
      _bodyController.clear();
    } on MailerException catch (e) {
      await FirebaseFirestore.instance.collection('EmailLogs').add({
        'to': recipient,
        'from': dotenv.env["GMAIL_EMAIL"],
        'subject': subject,
        'status': 'failed',
        'timestamp': FieldValue.serverTimestamp(),
        'sentBy': adminId,
        'errorMessage': e.problems.map((p) => '${p.code}: ${p.msg}').join('; '),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send email.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Mail From Gmail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: InputDecoration(labelText: 'Recipient Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Send Mail From Gmail"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendMailFromGmail();
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
