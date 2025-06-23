import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qoi_web/admin_navigation_banner.dart';

class AdminMajorsPage extends StatefulWidget {
  @override
  State<AdminMajorsPage> createState() => _AdminMajorsPageState();
}

class _AdminMajorsPageState extends State<AdminMajorsPage> {
  List<String> filieres = [];
  Map<String, List<String>> semesters = {};  // filiere -> semesters list
  Set<String> expandedFilieres = {};

  @override
  void initState() {
    super.initState();
    fetchFilieres();
  }

  Future<void> fetchFilieres() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/'));
    if (response.statusCode == 200) {
      setState(() {
        filieres = List<String>.from(json.decode(response.body));
      });
    }
  }

  Future<void> fetchSemesters(String filiere) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/filieres/$filiere/semesters/'));
    if (response.statusCode == 200) {
      setState(() {
        semesters[filiere] = List<String>.from(json.decode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AdminNavigationBanner(
          onNavigate: (route) => Navigator.pushNamed(context, route),
          activeRoute: '/admin-majors',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: filieres.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: filieres.map((filiere) {
                  final isExpanded = expandedFilieres.contains(filiere);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isExpanded) {
                            setState(() {
                              expandedFilieres.remove(filiere);
                            });
                          } else {
                            await fetchSemesters(filiere);
                            setState(() {
                              expandedFilieres.add(filiere);
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            filiere,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (isExpanded)
                        semesters[filiere] == null
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: semesters[filiere]!
                                    .map((semester) => ListTile(
                                          title: Text(semester),
                                          contentPadding: EdgeInsets.only(left: 48),
                                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                          onTap: () {
                                            Navigator.pushNamed(context, '/subjects_list', arguments: {
                                              'filiere': filiere,
                                              'semester': semester,
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                      SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),
      ),
    );
  }
}
