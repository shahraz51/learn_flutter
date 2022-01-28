import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductC with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavorite;

  ProductC(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isfavorite = false});

  Future<void> myfavorite(String token, String userid) async {
    final oldstate = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();
    try {
      final url =
          'https://shop-app-16a74-default-rtdb.firebaseio.com/userfavorite/$userid/$id.json?auth=$token';
      final response = await http.put(Uri.parse(url),
          body: json.encode(
            isfavorite
          ));
      if (response.statusCode >= 400) {
        isfavorite = oldstate;
        notifyListeners();
      }
    } catch (e) {
      isfavorite = oldstate;
      notifyListeners();
    }
  }
}
