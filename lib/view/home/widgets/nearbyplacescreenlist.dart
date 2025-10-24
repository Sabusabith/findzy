import 'dart:ui';
import 'package:findzy/core/controller/nearby_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NearbyPlacePage extends StatelessWidget {
  final String placeType;
  final Color startColor;
  final Color endColor;
  final String osmTag;
  final String osmkey;
  double distance;

  NearbyPlacePage({
    Key? key,
    required this.placeType,
    required this.startColor,
    required this.endColor,
    required this.osmTag,
    required this.distance,
    required this.osmkey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      NearbyPlaceController(
        placeType: placeType,
        osmValue: osmTag,
        osmKey: osmkey,
        radiusInMeters: distance,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leadingWidth: 44,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        title: Text(
          "Nearby ${placeType[0].toUpperCase()}${placeType.substring(1)}",
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCircle(color: startColor, size: 50.0),
                const SizedBox(height: 16),
                Text(
                  "Please wait...",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.places.isEmpty) {
          return Center(
            child: Text(
              "No $placeType found nearby.",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.places.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final place = controller.places[index];

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  place['name'],
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 2,
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: place['isOpen']
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  place['isOpen'] ? "Open" : "Closed",
                                  style: GoogleFonts.nunito(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            place['address'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Distance
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: startColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${place['distance']} km",
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                        color: startColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Open/Closed status

                              // Navigation button
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.location,
                                      color: startColor,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      controller.openInMaps(
                                        place['lat'],
                                        place['lon'],
                                      );
                                    },
                                  ),
                                  Text(
                                    "Locate Me",
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey.shade500,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
