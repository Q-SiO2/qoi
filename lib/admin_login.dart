import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final Color buttonColor = const Color(0xFF0093ED);
  final Color focusColor = const Color(0xFFFF3FA2);

  Future<void> login() async {
    setState(() => isLoading = true);

    final url = Uri.parse("https://qoi.onrender.com/accounts/admin-login/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("admin_id", data["id"].toString());
      await prefs.setString("admin_email", data["email"]);
      Navigator.pushReplacementNamed(context, "/admin-upload");
    } else {
      final data = json.decode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(data["message"] ?? "Unknown error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND SVG
          Positioned.fill(
            child: Image.asset(
              'assets/forlogin.png',
              fit: BoxFit.cover,
            ),
          ),

          // LOGIN CARD
          Center(
            child: Container(
              width: screenWidth * 0.33,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEA), // cream
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(4, 8),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(color: Colors.black),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Center(
                        child: Image.asset(
                          'assets/adminloginlogo.png',
                          height: 60,
                        )
                      ),
                    ),

                    // EMAIL FIELD
                    TextField(
                      controller: emailController,
                      style: GoogleFonts.spaceGrotesk(),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.spaceGrotesk(),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: focusColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD FIELD
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: GoogleFonts.spaceGrotesk(),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.spaceGrotesk(),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: focusColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Login",
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
