import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/admin/email/email_send_details.dart';
import 'package:project1/admin/sms/send_sms_details.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  AnalyticsDashboardState createState() => AnalyticsDashboardState();
}

class AnalyticsDashboardState extends State<AnalyticsDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  // Analytics data
  int _totalUsers = 0;
  int _totalApiCalls = 0;
  int _totalEmails = 0;
  int _totalSms = 0;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);

    try {
      final usersSnapshot = await _firestore.collection('Users').count().get();
      _totalUsers = usersSnapshot.count ?? 0;

      final apiCallsSnapshot =
          await _firestore.collection('ApiLogs').count().get();
      _totalApiCalls = apiCallsSnapshot.count ?? 0;

      final emailsSnapshot =
          await _firestore.collection('EmailLogs').count().get();
      _totalEmails = emailsSnapshot.count ?? 0;

      final smsSnapshot = await _firestore.collection('SMSLogs').count().get();
      _totalSms = smsSnapshot.count ?? 0;

      setState(() => _isLoading = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading analytics: ${e.toString()}')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & Logs')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalyticsData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsGrid(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total Users', _totalUsers, Icons.people),
        _buildStatCard('API Calls', _totalApiCalls, Icons.api),
        _buildStatCard('Emails Sent', _totalEmails, Icons.email),
        _buildStatCard('SMS Sent', _totalSms, Icons.sms),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Emails Sent') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailSendDetails()),
          );
        } else if (title == 'SMS Sent') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SendSMSDetails()),
          );
        }
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
