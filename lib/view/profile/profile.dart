import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Outer dark background
      body: Column(
        children: [
          const SizedBox(height: 60), // 👈 Push the section a bit lower
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Custom top bar
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ), // small gap below shadow
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4), // shadow color
                          offset: const Offset(0, 6), // move shadow downward
                          blurRadius: 20, // how soft the shadow looks
                          spreadRadius: 2, // how far it spreads
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15,
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          "Profile",
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content scrollable
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF2A2A2A),
                              child: Text(
                                "Z",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Zaab",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "zaabmadhukkal@gmail.com",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                        Text(
                          "LOGGING",
                          style: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 28),

                        _settingTile(
                          icon: Icons.settings_outlined,
                          title: "Account settings",
                          trailingIcon: Icons.open_in_new,
                          onTap: () {},
                        ),

                        const SizedBox(height: 50),

                        _primaryButton(
                          label: "Sign out",
                          color: const Color(0xFF3A3A3A),
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 12),
                        _outlinedButton(
                          label: "Delete account",
                          borderColor: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ],
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

  Widget _settingTile({
    IconData? icon,
    required String title,
    String? value,
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: Colors.white70, size: 24)
            : null,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailingIcon != null
            ? Icon(trailingIcon, color: Colors.white54, size: 20)
            : (value != null
                  ? Text(
                      value,
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    )
                  : null),
        onTap: onTap,
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _outlinedButton({
    required String label,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
