import 'package:findzy/core/constants/app_colors.dart';
import 'package:findzy/view/home/widgets/webview.dart';
import 'package:findzy/view/search/controller/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  final SearchControllerX controller = Get.find<SearchControllerX>();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor2,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 SEARCH BAR
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Color(0xFF0E0F20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1C2D),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
                  cursorColor: Colors.white,
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "Search for places, shops, leads...",
                    hintStyle: GoogleFonts.nunito(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white10, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: kPrimaryColor.withOpacity(.7),
                        width: 1,
                      ),
                    ),
                    suffixIcon: Icon(
                      CupertinoIcons.search,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 🔹 RESULTS SECTION
            Expanded(
              child: Obx(() {
                if (controller.query.value.isEmpty) {
                  return _emptyState();
                }

                // 🔹 SHOW LOADING
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.greenAccent,
                      strokeWidth: 2.2,
                    ),
                  );
                }

                // 🔹 SHOW RESULTS
                if (controller.results.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found",
                      style: GoogleFonts.nunito(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.results.length,
                  itemBuilder: (_, i) {
                    final item = controller.results[i];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1C2D),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Main Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.greenAccent,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  item["display_name"] ?? "",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // 🔹 Action Buttons INSIDE card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  controller.openWebSearch(
                                    item["display_name"] ?? "",
                                    item["address"]?["road"] ?? "",
                                    lat: double.tryParse(
                                      item["lat"].toString(),
                                    ),
                                    lon: double.tryParse(
                                      item["lon"].toString(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.language,
                                  color: Colors.greenAccent,
                                ),
                                label: Text(
                                  "Search",
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              ),

                              TextButton.icon(
                                onPressed: () {
                                  controller.openInMaps(
                                    double.parse(item["lat"].toString()),
                                    double.parse(item["lon"].toString()),
                                    item["display_name"] ?? "",
                                  );
                                },
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.greenAccent,
                                ),
                                label: Text(
                                  "Locate",
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 NO SEARCH STATE
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.search, color: Colors.white24, size: 40),
          const SizedBox(height: 12),
          Text(
            "Search for something...",
            style: GoogleFonts.nunito(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 🔹 RESULT CARD UI
}
