import 'package:findzy/core/constants/app_colors.dart';
import 'package:findzy/core/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: kBgColor2,

      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Settings",
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              color: kCardColor2,
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _settingsTile(
                    icon: Icons.person_outline,
                    title: "Profile",
                    subtitle: "",
                    onTap: () {
                      Get.toNamed(Routes.PROFILE);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(color: Colors.white12),
                  ),
                  _settingsTile(
                    icon: Icons.home_outlined,
                    title: "My homes",
                    subtitle: "",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Accounts
            SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "My History",
                style: textTheme.labelSmall!.copyWith(
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 15),

            _settingsTile(
              icon: Icons.lightbulb_outline,
              title: "Lights",
              subtitle: "Manage your lights and plugs",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.add_circle_outline,
              title: "Add a Hue Bridge",
              subtitle: "",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.mic_none,
              title: "Voice assistants",
              subtitle: "",
              onTap: () {},
            ),

            const SizedBox(height: 30),

            // Info Card
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: kCardColor2,
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      leading: Icon(icon, color: Colors.white, size: 26),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: GoogleFonts.inter(color: Colors.white60, fontSize: 13),
            )
          : null,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
    );
  }
}
