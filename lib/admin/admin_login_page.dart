import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededeb),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 2,
            ),
            padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 53, 51, 51), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(
                  MediaQuery.of(context).size.width,
                  110.0,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Admin Login Page",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50.0),
                          buildTextField(
                            controller: usernameController,
                            hintText: "Username",
                            validatorMsg: "Please Enter Username",
                          ),
                          const SizedBox(height: 30.0),
                          buildTextField(
                            controller: passwordController,
                            hintText: "Password",
                            validatorMsg: "Please Enter Password",
                            obscureText: true,
                          ),
                          const SizedBox(height: 40.0),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                loginAdmin();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String validatorMsg,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0, top: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 160, 160, 147)),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorMsg;
            }
            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 160, 160, 147),
            ),
          ),
        ),
      ),
    );
  }

  void loginAdmin() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Admin")
          .where("id", isEqualTo: usernameController.text.trim())
          .where("password", isEqualTo: passwordController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        //  Save the logged-in admin ID
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_id', usernameController.text.trim());

        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Invalid username or password",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error logging in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Login failed. Please try again later.",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }
}
