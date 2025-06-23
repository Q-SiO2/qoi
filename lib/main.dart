// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:qoi_web/admin_navigation_banner.dart';
import 'prof_login.dart';
import 'session_export.dart';

import 'semester_export.dart';
import 'admin_upload_screen.dart';
import 'prof_navigation_banner.dart'; // Adjust this path!
import 'landing_page.dart';
import 'admin_login.dart';
import 'professor_home_page.dart';
import 'admin_majors.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qoi.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LandingPage(),

      routes: {
        '/home': (context) => LandingPage(),
        '/export-session': (context) => AttendanceExportPage(),
        '/export-semester': (context) => SemesterExportPage(),
        '/prof-login': (context) => const ProfLoginPage(),
        '/admin-login': (context) => const AdminLoginPage(),
        '/admin-majors': (context) => AdminMajorsPage(),
        '/prof-home': (context) => const ProfessorHomePage(),
        '/admin-upload': (context) => FileUploadScreenUp(
          studentUploadUrl: 'https://qoi.onrender.com/accounts/upload-students/',
          scheduleUploadUrl: 'https://qoi.onrender.comaccounts/upload-timetable/'
          )

      }
    );
  }
}

