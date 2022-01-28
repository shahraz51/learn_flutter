import 'package:flutter/material.dart';

class Cartitem with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final int quantity;
  Cartitem(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});
}

class CartC with ChangeNotifier {
  Map<String, Cartitem> _item = {};
  Map<String, Cartitem> get item {
    return _item;
  }

  void addcartitem(String prid, String name, double price) {
    if (_item.containsKey(prid)) {
      _item.update(
          prid,
          (value) => Cartitem(
              id: value.id,
              name: value.name,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _item.putIfAbsent(
          prid,
          () => Cartitem(
              id: DateTime.now().toString(),
              name: name,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  double get totalamount {
    var total = 0.0;
    _item.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get itemlength {
    return _item.length;
  }

  void removthisid(String id) {
    _item.remove(id);
    notifyListeners();
  }

  void removesingleitem(String prid) {
    if (!_item.containsKey(prid)) {
      return;
    }
    if (_item[prid]!.quantity > 1) {
      _item.update(
          prid,
          (value) => Cartitem(
              id: value.id,
              name: value.name,
              price: value.price,
              quantity: value.quantity - 1));
    } else {
      item.remove(prid);
    }
    notifyListeners();
  }

  void clear() {
    _item.clear();
  }
}
