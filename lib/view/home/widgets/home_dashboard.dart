import 'package:findzy/view/home/controller/home_controller.dart';
import 'package:findzy/view/home/widgets/leads_list.dart';
import 'package:findzy/view/home/widgets/nearbyplacescreenlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Example destination pages
class ATMScreen extends StatelessWidget {
  ATMScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nearby ATMs')),
    body: const Center(child: Text('ATM Locations Page')),
  );
}

class PoliceScreen extends StatelessWidget {
  const PoliceScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Police Stations')),
    body: const Center(child: Text('Police Station Page')),
  );
}

class TheatersScreen extends StatelessWidget {
  const TheatersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Theaters')),
    body: const Center(child: Text('Theaters Page')),
  );
}

class HomeDashboard extends StatelessWidget {
  HomeDashboard({super.key, required this.distance});
  double distance;
  final HomeController hcontroller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.8, // wide rectangular shape
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              bool hasPermission = await hcontroller.checkAndRequestLocation(
                context,
              );

              if (!hasPermission) return;
              if (hcontroller.currentAddress.value == 'Locating...' ||
                  hcontroller.currentAddress.value == 'Updating...') {
                Get.snackbar(
                  "Locating Address...",
                  "Please wait while we fetch your location.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black.withOpacity(0.4), // glassy dark
                  overlayBlur: 6, // stronger blur for glass effect
                  borderRadius: 16,
                  margin: const EdgeInsets.all(16),
                  duration: const Duration(seconds: 3),
                  colorText: Colors.white,
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.lightBlueAccent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  forwardAnimationCurve: Curves.easeOutBack,
                  reverseAnimationCurve: Curves.easeIn,
                );
              } else {
                Get.to(
                  () => NearbyPlacePage(
                    placeType: item['title'], // e.g., 'hospital', 'petrol'
                    osmTag: item['osmValue'],
                    osmkey: item['osmKey'],
                    startColor: item['gradient'][0], // first gradient color
                    endColor: item['gradient'][1],
                    distance: distance,

                    // second gradient color
                  ),
                );
              }
            },
            child: _GradientCard(
              title: item['title'],
              icon: item['icon'],
              gradientColors: item['gradient'],
            ),
          );
        }, childCount: items.length),
      ),
    );
  }
}

class _GradientCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  const _GradientCard({
    required this.title,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(2, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            bottom: 8,
            child: Icon(icon, color: Colors.white.withOpacity(0.25), size: 60),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.3,
                  height: 1.1, // ✅ prevents breaking text into second line
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
