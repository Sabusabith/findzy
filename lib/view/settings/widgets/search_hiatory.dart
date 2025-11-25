import 'package:findzy/core/constants/app_colors.dart';
import 'package:findzy/view/home/widgets/webview.dart';
import 'package:findzy/view/search/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchHistoryPage extends StatelessWidget {
  SearchHistoryPage({super.key});

  final Box historyBox = Hive.box('search_history');
  final SearchControllerX controller = Get.find<SearchControllerX>();

  @override
  Widget build(BuildContext context) {
    // Load history as List<Map<String, dynamic>>
    List<Map<String, dynamic>> history = List<Map<String, dynamic>>.from(
      historyBox.get('items', defaultValue: <Map<String, dynamic>>[]),
    );

    return Scaffold(
      backgroundColor: kBgColor2,
      appBar: AppBar(
        toolbarHeight: 75,
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
        backgroundColor: kCardColor2,
        elevation: 0,
        title: Text(
          "Search History",
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? _emptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final item = history[index];
                final isExpanded = false.obs;

                return Obx(
                  () => GestureDetector(
                    onTap: () => isExpanded.value = !isExpanded.value,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCardColor2,
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
                                  maxLines: isExpanded.value ? null : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // Delete button
                              InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  history.removeAt(index);
                                  historyBox.put('items', history);
                                  (context as Element).reassemble();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white30,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // 🔹 Expanded buttons
                          if (isExpanded.value) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    controller.openWebSearch(
                                      item["display_name"] ?? "",
                                      item["address"] ?? "",
                                      lat: item["lat"] != null
                                          ? double.tryParse(
                                              item["lat"].toString(),
                                            )
                                          : null,
                                      lon: item["lon"] != null
                                          ? double.tryParse(
                                              item["lon"].toString(),
                                            )
                                          : null,
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
                                    if (item["lat"] != null &&
                                        item["lon"] != null) {
                                      controller.openInMaps(
                                        double.parse(item["lat"].toString()),
                                        double.parse(item["lon"].toString()),
                                        item["display_name"] ?? "",
                                      );
                                    }
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 48, color: Colors.white24),
          const SizedBox(height: 12),
          Text(
            "No search history available",
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
