import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shahroo_51/provider/Cart.dart';
import 'package:http/http.dart' as http;

class Orderitem {
  final String id;
  final double amount;
  final DateTime date;
  final List<Cartitem> whatyouorder;
  Orderitem(
      {required this.id,
      required this.amount,
      required this.date,
      required this.whatyouorder});
}

class OrderO with ChangeNotifier {
  final String authtoken;
  OrderO( this.authtoken, this._item);
  List<Orderitem> _item = [];
  List<Orderitem> get item {
    return [..._item];
  }

  Future<void> fetchorder() async {
    final url = "https://shop-app-16a74-default-rtdb.firebaseio.com/order.json?auth=$authtoken";
    final responseOrder = await http.get(Uri.parse(url));
    final List<Orderitem> loadedorder = [];
    
   try {
     final extractdata = json.decode(responseOrder.body) as Map<String, dynamic>;
     extractdata.forEach((key, value) {
      loadedorder.add(Orderitem(
          id: key,
          amount: value["total"],
          date: DateTime.parse(value["datetime"]),
          whatyouorder: (value["products"] as List<dynamic>)
              .map((e) => Cartitem(
                  id: e["id"],
                  name: e["name"],
                  price: e["price"],
                  quantity: e["quantity"]))
              .toList()));
    });
    _item = loadedorder.reversed.toList();
    notifyListeners();
   } catch (e) {
     return;
   }
    
    
  }

  Future<void> addOrder(
    double total,
    List<Cartitem> whatyouorder,
  ) async {
    final url = "https://shop-app-16a74-default-rtdb.firebaseio.com/order.json?auth=$authtoken";
    final realtime = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          "datetime": realtime.toIso8601String(),
          "total": total,
          "products": whatyouorder
              .map((value) => {
                    "id": value.id,
                    "name": value.name,
                    "price": value.price,
                    "quantity": value.quantity
                  })
              .toList(),
        }));
    _item.insert(
      0,
      Orderitem(
          id: DateTime.now().toString(),
          amount: total,
          date: DateTime.now(),
          whatyouorder: whatyouorder),
    );
    notifyListeners();
  }
}
