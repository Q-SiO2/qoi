// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qoi_web/prof_navigation_banner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'prof_login.dart';


class ProfessorHomePage extends StatefulWidget {
  const ProfessorHomePage({super.key});

  @override
  State<ProfessorHomePage> createState() => _ProfessorHomePageState();
}


class _ProfessorHomePageState extends State<ProfessorHomePage> {
  late Future<List<dynamic>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _loadProfessorIdAndFetchSessions();
  }

  Future<void> _loadProfessorIdAndFetchSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('professor_id');

    if (id == null) {
      // No ID found — redirect to login maybe
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() {
      String professorId = id;
      _sessionsFuture = fetchSessions(professorId);
    });
  }

  Future<List<dynamic>> fetchSessions(String profId) async {
    final response = await http.get(
      Uri.parse('https://qoi.onrender.com/accounts/prof-today/$profId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: ProfNavigationBanner(
          onNavigate: (route) => Navigator.pushNamed(context, route),
          activeRoute: '/prof-home',
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load sessions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sessions scheduled for today'));
          }

          final sessions = snapshot.data!;
          final today = DateFormat.yMMMMd().format(DateTime.now());

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            children: [
              // Title
              Text(
                "Your sessions for the day",
                style: const TextStyle(
                  fontFamily: 'Ds-Digital',
                  fontSize: 45,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                today,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 40),

              // List of session cards
              ...sessions.map((s) => AnimatedSessionCard(session: s)).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 32),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}


class AnimatedSessionCard extends StatefulWidget {
  final Map session;

  const AnimatedSessionCard({required this.session, super.key});

  @override
  _AnimatedSessionCardState createState() => _AnimatedSessionCardState();
}

class _AnimatedSessionCardState extends State<AnimatedSessionCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void toggleCard() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.6),
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Card(
          color: Colors.grey,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: InkWell(
            onTap: toggleCard,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    session['subject_name'] ?? 'No Subject',
                    style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    session['group_name'] ?? 'No Groupe',
                    style: GoogleFonts.spaceGrotesk(color: Colors.white70),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        session['session_date'] ?? 'No Date',
                        style: GoogleFonts.spaceGrotesk(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "${session['start_time']} - ${session['end_time']}",
                        style: GoogleFonts.spaceGrotesk(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: session['encoded_data'] != null
                        ? QrImageView(
                            data: session['encoded_data'],
                            size: 200,
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            "No QR data available",
                            style: GoogleFonts.spaceGrotesk(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
