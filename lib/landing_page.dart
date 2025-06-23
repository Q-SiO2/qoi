import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey howItWorksKey = GlobalKey();
  final GlobalKey securityKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey getStartedKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget navItem(String title, GlobalKey key) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => scrollToSection(key),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: scrollToTop,
        backgroundColor: Colors.black,
        child: const Icon(Icons.arrow_upward),
      ),
      body: DefaultTextStyle(
        style: GoogleFonts.spaceGrotesk(color: Colors.black),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // NAVBAR
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    navItem("How it Works", howItWorksKey),
                    navItem("Security", securityKey),
                    navItem("About Us", aboutKey),
                    navItem("Get Started", getStartedKey),
                  ],
                ),
              ),

              // HERO SECTION
              Stack(
                children: [
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/landingdrop.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 500,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/hugiologo.png',
                          height: 110,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Attendance. Simplified.",
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Designed for Professors and Admins.",
                          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => scrollToSection(getStartedKey),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Get Started", style: GoogleFonts.spaceGrotesk(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //how it works
              howItWorksSection(),
              // SECURITY
              securitySection(),

              // ABOUT
              aboutUsSection(),


              // GET STARTED
              getStartedSection(),

              footer(),


            ],
          ),
        ),
      ),
    );
  }

  Widget section({required String title, required String content, required Key key}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.spaceGrotesk(fontSize: 18),
          ),
        ],
      ),
    );
  }


  Widget howItWorksCard({
    required IconData icon,
    required String step,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(4, 8),
          ),
        ],
        borderRadius: BorderRadius.zero, // no rounding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.black87),
          const SizedBox(height: 16),
          Text(
            step,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.spaceGrotesk(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }




  Widget howItWorksSection() {
    return Container(
      key: howItWorksKey,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "How It Works",
            style: TextStyle(
              fontFamily: 'Hugio', // You must have Hugio font locally or imported via pub
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Discover the ease of Qoi in 3 seamless steps.",
            style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.black87),
          ),
          const SizedBox(height: 40),

          // CARD ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card 1
              Expanded(
                child: howItWorksCard(
                  icon: Icons.qr_code_2_rounded,
                  step: "Step One",
                  text: "Each QR is automatically generated just before class begins.",
                ),
              ),
              const SizedBox(width: 20),

              // Card 2
              Expanded(
                child: howItWorksCard(
                  icon: Icons.phone_android_rounded,
                  step: "Step Two",
                  text: "Students scan using the mobile app. It's fast and effortless.",
                ),
              ),
              const SizedBox(width: 20),

              // Card 3
              Expanded(
                child: howItWorksCard(
                  icon: Icons.lock_outline_rounded,
                  step: "Step Three",
                  text: "All data is secured and access is restricted by roles.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget securityCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(4, 8),
          ),
        ],
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.black87),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.spaceGrotesk(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }







  Widget securitySection() {
    return Stack(
      key: securityKey,
      children: [
        // Background image
        SizedBox(
          height: 550,
          width: double.infinity,
          child: Image.asset(
            'assets/secdrop.png',
            fit: BoxFit.cover,
          ),
        ),

        // Content
        Container(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
          height: 550,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Security & Confidentiality",
                style: TextStyle(
                  fontFamily: 'Hugio', // Custom Hugio font
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Every user enjoys protected access, controlled roles, and encrypted data.",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Card 1
                  Expanded(
                    child: securityCard(
                      icon: Icons.shield_rounded,
                      title: "Secure Access",
                      description: "Every login is protected by robust authentication protocols and secure credential handling.",
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Card 2
                  Expanded(
                    child: securityCard(
                      icon: Icons.verified_user_rounded,
                      title: "Role-Based Control",
                      description: "Permissions are tightly scoped. Professors, admins, and students each have distinct access layers.",
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Card 3
                  Expanded(
                    child: securityCard(
                      icon: Icons.lock_rounded,
                      title: "Data Encryption",
                      description: "All attendance data is encrypted at rest and in transit using industry-standard protocols.",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }




  Widget aboutUsSection() {
    return Container(
      key: aboutKey,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hugio title
          Text(
            "About Us",
            style: TextStyle(
              fontFamily: 'Hugio',
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Paragraph
          Text(
            "Qoi is more than a tool — it's a statement. Built by students who know the value of time, respect the rhythm of the classroom, and dream of a smoother future for faculty and administration alike. We believe in simple systems that just work, in elegant code, and in thoughtful design that puts people first.",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),

          // Optional: add founders/info highlight
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                "Made with care, curiosity, and way too much coffee.",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget getStartedCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(4, 8),
            ),
          ],
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 48, color: Colors.black87),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.spaceGrotesk(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }







  Widget getStartedSection() {
    return Stack(
      key: getStartedKey,
      children: [
        // Background
        Positioned.fill(
          child: Image.asset(
            'assets/getstarteddrop.png',
            fit: BoxFit.cover,
          ),
        ),

        // Foreground
        Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get Started",
                style: TextStyle(
                  fontFamily: 'Hugio',
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Choose your access method to begin using Qoi.",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                children: [
                  // Professor Card
                  Expanded(
                    child: getStartedCard(
                      icon: Icons.person_outline,
                      title: "Professor Login",
                      description: "Log in to start displaying QR codes for your classes. Attendance will be tracked automatically for each session.",
                      onTap: () => Navigator.pushNamed(context, '/prof-login'),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Admin Card
                  Expanded(
                    child: getStartedCard(
                      icon: Icons.admin_panel_settings_outlined,
                      title: "Admin Login",
                      description: "Admins gain access to full institutional attendance data and control over user roles and sessions.",
                      onTap: () => Navigator.pushNamed(context, '/admin-login'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget footer() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Qoi.", style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            "123 Campus Avenue, Somewhere, Morocco\ncontact@qoi.app • +212 600-000000",
            style: GoogleFonts.spaceGrotesk(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Text(
            "© 2025 Qoi.solutions All rights reserved.",
            style: GoogleFonts.spaceGrotesk(fontSize: 14, color: Colors.white54),
          ),
        ],
      ),
    );
  }



}
