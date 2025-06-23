import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:qoi_web/admin_navigation_banner.dart';

class FileUploadScreenUp extends StatefulWidget {
  final String studentUploadUrl;
  final String scheduleUploadUrl;

  const FileUploadScreenUp({
    Key? key,
    required this.studentUploadUrl,
    required this.scheduleUploadUrl,
  }) : super(key: key);

  @override
  State<FileUploadScreenUp> createState() => _FileUploadScreenUpState();
}

class _FileUploadScreenUpState extends State<FileUploadScreenUp> {
  PlatformFile? studentFile;
  PlatformFile? scheduleFile;
  String message = '';
  bool _isUploading = false;

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (type == 'student') {
          studentFile = result.files.first;
        } else {
          scheduleFile = result.files.first;
        }
      });
    }
  }

  Future<void> _uploadFiles() async {
    if (studentFile == null || scheduleFile == null) {
      setState(() {
        message = 'Select both files before uploading!';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      message = '';
    });

    try {
      final req1 = http.MultipartRequest(
        'POST',
        Uri.parse(widget.studentUploadUrl),
      )..files.add(
          http.MultipartFile.fromBytes(
            'file',
            studentFile!.bytes!,
            filename: studentFile!.name,
          ),
        );

      final res1 = await req1.send();

      final req2 = http.MultipartRequest(
        'POST',
        Uri.parse(widget.scheduleUploadUrl),
      )..files.add(
          http.MultipartFile.fromBytes(
            'file',
            scheduleFile!.bytes!,
            filename: scheduleFile!.name,
          ),
        );

      final res2 = await req2.send();

      setState(() {
        if (res1.statusCode == 200 && res2.statusCode == 200) {
          message = ' Both files uploaded successfully!';
        } else {
          message = 'Upload failed! Check your backend.';
        }
      });
    } catch (e) {
      setState(() {
        message = 'Upload failed: $e';
      });
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Widget _fileCard({
    required String label,
    required PlatformFile? file,
    required VoidCallback onTap,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: file != null ? Colors.green.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.zero,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              file?.name ?? label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AdminNavigationBanner(
          onNavigate: (route) => Navigator.pushNamed(context, route),
          activeRoute: '/admin-upload',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Add A New Class",
              style: const TextStyle(
                fontFamily: 'Ds-Digital',
                fontSize: 50,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _fileCard(
                  label: '📘 Pick Student File',
                  file: studentFile,
                  onTap: () => _pickFile('student'),
                ),
                _fileCard(
                  label: '🗓️ Pick Schedule File',
                  file: scheduleFile,
                  onTap: () => _pickFile('schedule'),
                ),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadFiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Upload Both Files',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),
            if (message.isNotEmpty)
              Text(
                message,
                style: GoogleFonts.spaceGrotesk(
                  color: message.contains('successfully') ? Colors.green : Colors.redAccent,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
