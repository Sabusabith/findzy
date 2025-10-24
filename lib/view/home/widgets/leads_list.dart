import 'package:flutter/material.dart';

final List<Map<String, dynamic>> items = const [
  // ⚡ Most Essential / Daily Needs
  {
    "title": "Hospitals",
    "icon": Icons.local_hospital,
    "gradient": [Color(0xFF11998E), Color(0xFF38EF7D)],
    "page": "hospital",
    "osmKey": "amenity",
    "osmValue": "hospital",
  },
  {
    "title": "Petrol Pumps",
    "icon": Icons.local_gas_station,
    "gradient": [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    "page": "petrol",
    "osmKey": "amenity",
    "osmValue": "fuel",
  },
  {
    "title": "ATMs",
    "icon": Icons.atm,
    "gradient": [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    "page": "atm",
    "osmKey": "amenity",
    "osmValue": "atm",
  },
  {
    "title": "Supermarkets",
    "icon": Icons.shopping_cart,
    "gradient": [Color(0xFF12c2e9), Color(0xFFc471ed)],
    "page": "supermarket",
    "osmKey": "shop",
    "osmValue": "supermarket",
  },
  {
    "title": "Restaurants",
    "icon": Icons.restaurant,
    "gradient": [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
    "page": "restaurant",
    "osmKey": "amenity",
    "osmValue": "restaurant",
  },
  {
    "title": "Cafes",
    "icon": Icons.local_cafe,
    "gradient": [Color(0xFFB24592), Color(0xFFF15F79)],
    "page": "cafe",
    "osmKey": "amenity",
    "osmValue": "cafe",
  },

  // 🏨 Accommodation & Security
  {
    "title": "Hotels",
    "icon": Icons.hotel,
    "gradient": [Color(0xFF6A11CB), Color(0xFF2575FC)],
    "page": "hotel",
    "osmKey": "tourism",
    "osmValue": "hotel",
  },
  {
    "title": "Police Station",
    "icon": Icons.local_police,
    "gradient": [Color(0xFF141E30), Color(0xFF243B55)],
    "page": "police",
    "osmKey": "amenity",
    "osmValue": "police",
  },
  {
    "title": "Parking",
    "icon": Icons.local_parking,
    "gradient": [Color(0xFFFFC837), Color(0xFFFF8008)],
    "page": "parking",
    "osmKey": "amenity",
    "osmValue": "parking",
  },

  // 🚍 Transport
  {
    "title": "Bus Stops",
    "icon": Icons.directions_bus,
    "gradient": [Color(0xFF16A085), Color(0xFFF4D03F)],
    "page": "busstop",
    "osmKey": "highway",
    "osmValue": "bus_stop",
  },
  {
    "title": "Railway Stations",
    "icon": Icons.train,
    "gradient": [Color(0xFF283E51), Color(0xFF485563)],
    "page": "railway",
    "osmKey": "railway",
    "osmValue": "station",
  },
  {
    "title": "Airports",
    "icon": Icons.flight_takeoff,
    "gradient": [Color(0xFF6DD5FA), Color(0xFF2980B9)],
    "page": "airport",
    "osmKey": "aeroway",
    "osmValue": "aerodrome",
  },

  // 🎭 Entertainment & Shopping
  {
    "title": "Theaters",
    "icon": Icons.theaters,
    "gradient": [Color(0xFFFF512F), Color(0xFFF09819)],
    "page": "theater",
    "osmKey": "amenity",
    "osmValue": "theatre",
  },
  {
    "title": "Shopping Malls",
    "icon": Icons.store_mall_directory,
    "gradient": [Color(0xFFf85032), Color(0xFFe73827)],
    "page": "mall",
    "osmKey": "shop",
    "osmValue": "mall",
  },
  {
    "title": "Parks",
    "icon": Icons.park,
    "gradient": [Color(0xFF00b09b), Color(0xFF96c93d)],
    "page": "park",
    "osmKey": "leisure",
    "osmValue": "park",
  },

  // 🎓 Education & Fitness
  {
    "title": "Schools",
    "icon": Icons.school,
    "gradient": [Color(0xFF11998E), Color(0xFF38EF7D)],
    "page": "school",
    "osmKey": "amenity",
    "osmValue": "school",
  },
  {
    "title": "Colleges",
    "icon": Icons.account_balance,
    "gradient": [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    "page": "college",
    "osmKey": "amenity",
    "osmValue": "college",
  },
  {
    "title": "Gyms",
    "icon": Icons.fitness_center,
    "gradient": [Color(0xFFe53935), Color(0xFFe35d5b)],
    "page": "gym",
    "osmKey": "leisure",
    "osmValue": "fitness_centre",
  },

  // ⛪ Religious Places
  {
    "title": "Mosques",
    "icon": Icons.mosque,
    "gradient": [Color(0xFF009245), Color(0xFFFCEE21)],
    "page": "mosque",
    "osmKey": "amenity",
    "osmValue": "place_of_worship",
  },
  {
    "title": "Churches",
    "icon": Icons.church,
    "gradient": [Color(0xFF1D2671), Color(0xFFC33764)],
    "page": "church",
    "osmKey": "amenity",
    "osmValue": "place_of_worship",
  },
  {
    "title": "Temples",
    "icon": Icons.temple_hindu,
    "gradient": [Color(0xFFF2994A), Color(0xFFF2C94C)],
    "page": "temple",
    "osmKey": "amenity",
    "osmValue": "place_of_worship",
  },

  // 🐾 Services & Shops
  {
    "title": "Pet Shops",
    "icon": Icons.pets,
    "gradient": [Color(0xFFf7971e), Color(0xFFFFD200)],
    "page": "petshop",
    "osmKey": "shop",
    "osmValue": "pet",
  },
  {
    "title": "Workshops",
    "icon": Icons.build,
    "gradient": [Color(0xFF434343), Color(0xFF000000)],
    "page": "workshop",
    "osmKey": "shop",
    "osmValue": "car_repair",
  },
  {
    "title": "Electronics Repair",
    "icon": Icons.electrical_services,
    "gradient": [Color(0xFF36D1DC), Color(0xFF5B86E5)],
    "page": "electronics",
    "osmKey": "shop",
    "osmValue": "electronics",
  },
];
