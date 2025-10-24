//old styles................................

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomeDashboard extends StatelessWidget {
//   const HomeDashboard({super.key});

//   final List<Map<String, dynamic>> _items = const [
//     {
//       "title": "Hotels",
//       "icon": Icons.hotel,
//       "gradient": [Color(0xFF6A11CB), Color(0xFF2575FC)],
//     },
//     {
//       "title": "Hospitals",
//       "icon": Icons.local_hospital,
//       "gradient": [Color(0xFF11998E), Color(0xFF38EF7D)],
//     },
//     {
//       "title": "Petrol Pumps",
//       "icon": Icons.local_gas_station,
//       "gradient": [Color(0xFFFF416C), Color(0xFFFF4B2B)],
//     },
//     {
//       "title": "Restaurants",
//       "icon": Icons.restaurant,
//       "gradient": [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
//     },
//     {
//       "title": "Parking",
//       "icon": Icons.local_parking,
//       "gradient": [Color(0xFFFFC837), Color(0xFFFF8008)],
//     },
//     {
//       "title": "Pharmacies",
//       "icon": Icons.medical_services,
//       "gradient": [Color(0xFF36D1DC), Color(0xFF5B86E5)],
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // 2 columns
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 0.95,
//         ),
//         delegate: SliverChildBuilderDelegate((context, index) {
//           final item = _items[index];
//           return _GradientCard(
//             title: item['title'],
//             icon: item['icon'],
//             gradientColors: item['gradient'],
//           );
//         }, childCount: _items.length),
//       ),
//     );
//   }
// }

// class _GradientCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final List<Color> gradientColors;

//   const _GradientCard({
//     required this.title,
//     required this.icon,
//     required this.gradientColors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: gradientColors,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: gradientColors.last.withOpacity(0.4),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () {
//             // Navigate to respective category
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Icon with semi-transparent circle
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: Icon(icon, size: 40, color: Colors.white),
//                 ),
//                 const SizedBox(height: 16),
//                 // Title
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.nunito(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//new styles..................................

import 'package:findzy/view/home/widgets/leads_list.dart';
import 'package:findzy/view/home/widgets/nearbyplacescreenlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Example destination pages
class ATMScreen extends StatelessWidget {
  const ATMScreen({super.key});
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
            onTap: () {
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
