import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:findzy/view/home/widgets/webview.dart';

class SearchControllerX extends GetxController {
  RxString query = "".obs;
  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> results = <Map<String, dynamic>>[].obs;

  // ⭐ HIVE SEARCH HISTORY
  late Box historyBox;
  RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;

  Timer? debounce;
  final Dio dio = Dio();

  @override
  void onInit() async {
    super.onInit();

    // Open Hive box
    historyBox = Hive.box('search_history');

    // Load existing history as List<Map<String, dynamic>>
    final stored = historyBox.get('items', defaultValue: <Map>[]);
    history.assignAll(List<Map<String, dynamic>>.from(stored));
  }

  // ⭐ Save history ONLY when user selects a result
  // ⭐ Save history with optional lat/lon
  void saveHistory(String name, {double? lat, double? lon, String? address}) {
    if (name.trim().isEmpty) return;

    final item = {
      "display_name": name,
      if (lat != null) "lat": lat,
      if (lon != null) "lon": lon,
      if (address != null && address.isNotEmpty) "address": address,
    };

    history.removeWhere((e) => e["display_name"] == name);
    history.insert(0, item);

    if (history.length > 10) history.removeLast();
    historyBox.put('items', history);
  }

  // 🔍 SEARCH API (no history save here)
  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      results.clear();
      return;
    }

    isLoading.value = true;

    try {
      final response = await dio.get(
        "https://nominatim.openstreetmap.org/search",
        queryParameters: {
          "q": keyword,
          "format": "json",
          "addressdetails": 1,
          "limit": 20,
        },
        options: Options(
          headers: {"User-Agent": "Findzy/1.0 (contact@findzy.com)"},
        ),
      );

      results.value = List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print("Search API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ⌛ Debounce typing
  void onSearchChanged(String value) {
    query.value = value;

    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 350), () {
      search(value);
    });
  }

  // 🌍 Google web search
  void openWebSearch(String name, String address, {double? lat, double? lon}) {
    // Save history with optional coordinates
    saveHistory(name, lat: lat, lon: lon, address: address);

    final q = Uri.encodeComponent("$name $address");
    final url = "https://www.google.com/search?q=$q";

    Get.to(() => WebViewPage(title: name, url: url));
  }

  // 📍 MAP LOCATION OPEN
  Future<void> openInMaps(double lat, double lon, String title) async {
    saveHistory(title, lat: lat, lon: lon);
    final Uri googleSearchUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lon",
    );

    final Uri osmUrl = Uri.parse(
      "https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=18/$lat/$lon",
    );

    try {
      if (await canLaunchUrl(googleSearchUrl)) {
        await launchUrl(googleSearchUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(osmUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        "Navigation Error",
        "Unable to open map.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
