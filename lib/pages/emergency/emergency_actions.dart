// emergency_actions.dart
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch phone call to $phoneNumber';
  }
}

Future<void> sendSMS(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not send SMS to $phoneNumber';
  }
}

Future<void> sendEmail(String email) async {
  final Uri emailUri = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not send email to $email';
  }
}
