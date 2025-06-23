// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminNavigationBanner extends StatelessWidget {
  final void Function(String routeName) onNavigate;
  final String activeRoute;

  const AdminNavigationBanner({
    Key? key,
    required this.onNavigate,
    required this.activeRoute,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    onNavigate('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      color: Color.fromRGBO(0, 147, 237, 1),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            child: Image.asset(
              'assets/adminnavban.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 80),

          _HoverTextButton(
            label: 'Export Session',
            route: '/export-session',
            activeRoute: activeRoute,
            onTap: () => onNavigate('/export-session'),
          ),
          const SizedBox(width: 32),

          _HoverTextButton(
            label: 'Export Semester',
            route: '/export-semester',
            activeRoute: activeRoute,
            onTap: () => onNavigate('/export-semester'),
          ),
          const SizedBox(width: 32),

          _HoverTextButton(
            label: 'New Class',
            route: '/admin-upload',
            activeRoute: activeRoute,
            onTap: () => onNavigate('/admin-upload'),
          ),
          const Spacer(),

          ElevatedButton.icon(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverTextButton extends StatefulWidget {
  final String label;
  final String route;
  final String activeRoute;
  final VoidCallback onTap;

  const _HoverTextButton({
    Key? key,
    required this.label,
    required this.route,
    required this.activeRoute,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_HoverTextButton> createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<_HoverTextButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.route == widget.activeRoute;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? Colors.white
                : (_hovering ? Colors.white70 : Colors.white),
            decoration: isActive || _hovering ? TextDecoration.underline : TextDecoration.none,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
