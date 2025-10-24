import 'package:findzy/view/home/widgets/home_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    //distance dialogue
    void _showDistanceDialog(BuildContext context, HomeController controller) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Distance",
        pageBuilder: (context, anim1, anim2) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F2E),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Adjust Distance Range",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => Text(
                            "${controller.maxDistance.value.toStringAsFixed(1)} km",
                            style: GoogleFonts.nunito(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorColor: Colors.greenAccent,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Obx(
                            () => Column(
                              children: [
                                Slider(
                                  value: controller.maxDistance.value,
                                  min: 1,
                                  max: 30,
                                  divisions: 29,
                                  activeColor: Colors.greenAccent,
                                  inactiveColor: Colors.white24,
                                  label:
                                      "${controller.maxDistance.value.toStringAsFixed(1)} km",
                                  onChanged: (value) {
                                    controller.maxDistance.value = value;
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "⚠️ Higher distance may take longer to load results",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Done",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(
                  CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
                ),
            child: FadeTransition(opacity: anim1, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F20),
      body: Obx(() {
        int index = controller.selectedIndex.value;

        if (index == 0) {
          // First screen with SliverAppBar
          return CustomScrollView(
            physics: BouncingScrollPhysics(),

            slivers: [
              // 🔹 Collapsible AppBar
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromARGB(255, 1, 37, 72),

                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    var top = constraints.biggest.height;
                    double collapseFactor =
                        (top - kToolbarHeight) / (140 - kToolbarHeight);
                    collapseFactor = collapseFactor.clamp(0.0, 1.0);

                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                      title: Text(
                        "Explore Nearby",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12 + (6 * (1 - collapseFactor)), // 12 → 18
                        ),
                      ),

                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF003366), Color(0xFF0E0F20)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          top: 50,
                        ),
                        child: Opacity(
                          opacity: collapseFactor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, Mohammed",
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "Find your Leads",
                                    style: GoogleFonts.nunito(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => _showDistanceDialog(
                                      context,
                                      controller,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            Obx(
                                              () => Text(
                                                "${controller.maxDistance.value.toStringAsFixed(1)} km",
                                                style: GoogleFonts.nunito(
                                                  color: Colors.greenAccent,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Icon(
                                              Icons.trending_up,
                                              color: Colors.greenAccent,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                ],
                              ),
                              const SizedBox(height: 5),

                              Transform(
                                transform: Matrix4.translationValues(-3, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    SizedBox(width: 3),
                                    Obx(
                                      () => Text(
                                        controller.currentAddress.value,
                                        style: GoogleFonts.nunito(
                                          color: Colors.greenAccent,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Main content
              HomeDashboard(distance: controller.maxDistance.value * 1000),
            ],
          );
        } else {
          // Other screens without AppBar
          return IndexedStack(
            index: index,
            children: [
              const SizedBox.shrink(), // placeholder for first screen
              _routinesPage(),
              _explorePage(),
              _settingsPage(),
            ],
          );
        }
      }),

      // 🔹 Bottom Navigation
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          backgroundColor: const Color(0xFF151729),
          selectedItemColor: const Color(0xFF42A5F5),
          unselectedItemColor: Colors.white54,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              label: "Routines",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Widgets for First Page
  Widget _buildSceneCard(String title, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneImage(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLightCard(String title, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
        ),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Switch(value: true, onChanged: (_) {}, activeColor: Colors.white),
          ],
        ),
      ),
    );
  }

  // 🔹 Dummy Pages for Other Tabs
  Widget _routinesPage() => const Center(
    child: Text("Routines Page", style: TextStyle(color: Colors.white)),
  );
  Widget _explorePage() => const Center(
    child: Text("Explore Page", style: TextStyle(color: Colors.white)),
  );
  Widget _settingsPage() => const Center(
    child: Text("Settings Page", style: TextStyle(color: Colors.white)),
  );
}
