import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qoi_web/prof_navigation_banner.dart';

class AttendanceExportPage extends StatefulWidget {
  const AttendanceExportPage({super.key});

  @override
  State<AttendanceExportPage> createState() => _AttendanceExportPageState();
}

class _AttendanceExportPageState extends State<AttendanceExportPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _subjectController = TextEditingController();
  final _sessionDateController = TextEditingController();
  final _periodController = TextEditingController();

  // Dropdown values
  String? _selectedFiliere;
  String? _selectedYear;
  String? _selectedSemester;
  int? _selectedSubjectId;

  // Loading state
  bool _isLoading = false;

  // Options fetched from backend
  List<String> filieres = [];
  List<String> years = [];
  List<String> semesters = [];
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    await Future.wait([
      fetchGroupOptions(),
      fetchSubjects(),
    ]);
  }

  Future<void> fetchGroupOptions() async {
    final response = await http.get(Uri.parse('https://qoi.onrender.com/accounts/group-dropdowns/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        filieres = List<String>.from(data['filieres']);
        years = List<String>.from(data['years'].map((y) => y.toString()));
        semesters = List<String>.from(data['semesters'].map((s) => s.toString()));
      });
    }
  }

  Future<void> fetchSubjects() async {
    final response = await http.get(Uri.parse('https://qoi.onrender.com/accounts/subject-list/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        subjects = List<Map<String, dynamic>>.from(data);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _sessionDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _downloadExcel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final dio = Dio();
    final data = {
      "session_date": _sessionDateController.text,
      "filiere": _selectedFiliere,
      "year": int.parse(_selectedYear!),
      "semester": int.parse(_selectedSemester!),
      "subject_id": _selectedSubjectId,
      "period": _periodController.text,
    };

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/attendance_${data['session_date']}.xlsx";

      final response = await dio.post(
        'https://qoi.onrender.com/accounts/export-session/',
        data: data,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Downloaded: ${file.path}'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error ${response.statusCode}: ${response.statusMessage}'),
        ));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Download failed.'),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _sessionDateController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? selectedValue,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(), style: GoogleFonts.spaceGrotesk()),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.spaceGrotesk(color: Colors.pinkAccent),
        border: const OutlineInputBorder(),
      ),
      validator: (val) => val == null ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.7;

    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Export Session Attendance",
                    style: const TextStyle(
                      fontFamily: 'Ds-Digital',
                      fontSize: 50,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Row 1: Filière, Year, Semester
                  Row(
                    children: [
                      Expanded(child: _buildDropdown(label: "Major", selectedValue: _selectedFiliere, items: filieres, onChanged: (val) => setState(() => _selectedFiliere = val))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown(label: "Year", selectedValue: _selectedYear, items: years, onChanged: (val) => setState(() => _selectedYear = val))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown(label: "Semester", selectedValue: _selectedSemester, items: semesters, onChanged: (val) => setState(() => _selectedSemester = val))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 2: Date + Period
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _sessionDateController,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: InputDecoration(
                            labelText: "Session Date",
                            labelStyle: GoogleFonts.spaceGrotesk(),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _periodController,
                          decoration: InputDecoration(
                            labelText: "Period (e.g. 08:00-10:00)",
                            labelStyle: GoogleFonts.spaceGrotesk(),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 3: Subject
                  DropdownButtonFormField<int>(
                    value: _selectedSubjectId,
                    items: subjects.map<DropdownMenuItem<int>>((subject) {
                      return DropdownMenuItem<int>(
                        value: subject['id'],
                        child: Text(subject['name'], style: GoogleFonts.spaceGrotesk()),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSubjectId = val),
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      labelStyle: GoogleFonts.spaceGrotesk(color: Colors.pinkAccent),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      onPressed: _isLoading ? null : _downloadExcel,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.download, color: Colors.white),
                      label: Text(
                        _isLoading ? "Downloading..." : "Export to Excel",
                        style: GoogleFonts.spaceGrotesk(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
