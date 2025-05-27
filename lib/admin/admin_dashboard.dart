import 'package:flutter/material.dart';
import 'package:project1/admin/add_new_admin.dart';
import 'package:project1/admin/analytical_dashboard.dart';
import 'package:project1/admin/email/send_mail_page.dart';
import 'package:project1/admin/google_api_manage.dart';
import 'package:project1/admin/user_management.dart';
import 'package:project1/admin/sms/sms_management.dart';
import 'package:project1/admin/admin_login_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardCardItem> cards = [
      _DashboardCardItem(
        title: 'Google API Manage',
        icon: Icons.api,
        page: GoogleApiManager(),
      ),
      _DashboardCardItem(
        title: 'Admin User Manage',
        icon: Icons.admin_panel_settings,
        page: AddNewAdmin(),
      ),
      _DashboardCardItem(
        title: 'User Management',
        icon: Icons.people,
        page: UserManagement(),
      ),
      _DashboardCardItem(
        title: 'Send Email',
        icon: Icons.email,
        page: SendMailPage(),
      ),
      _DashboardCardItem(
        title: 'SMS Management',
        icon: Icons.sms,
        page: SMSManagement(),
      ),
      _DashboardCardItem(
        title: 'Analytics & Logs',
        icon: Icons.analytics,
        page: AnalyticsDashboard(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              // Navigate back to AdminPage when Sign Out button is clicked
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFf2f2f2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: cards.map((item) => _buildCard(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _DashboardCardItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 50, color: Colors.black),
              const SizedBox(height: 20),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCardItem {
  final String title;
  final IconData icon;
  final Widget page;

  _DashboardCardItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}
