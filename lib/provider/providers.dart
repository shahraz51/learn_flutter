import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shahroo_51/provider/Http_exception.dart';
import 'package:shahroo_51/provider/productClass.dart';
import 'package:http/http.dart' as http;

class ProviderP with ChangeNotifier {
  final String authtoken;
  ProviderP(this.authtoken, this._item);

  List<ProductC> _item = [
    ProductC(
      id: "b2",
      title: "pistol",
      description: "this old pistol that used in ww1",
      price: 70.00,
      imageUrl:
          "https://cdn.pixabay.com/photo/2017/02/08/23/31/gun-2050748_960_720.jpg",
    ),
  ];
  List<ProductC> get item {
    return [..._item];
  }

  List<ProductC> get onlyfavorite {
    return _item.where((element) => element.isfavorite).toList();
  }

  ProductC findbyid(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> FetchData() async {
    final url =
        "https://shop-app-16a74-default-rtdb.firebaseio.com/products.json?auth=$authtoken";
    try {
      final response = await http.get(Uri.parse(url));
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductC> loadedproduct = [];
      extracteddata.forEach((key, value) {
        loadedproduct.add(ProductC(
            id: key,
            title: value["title"],
            description: value["description"],
            price: value["price"],
            imageUrl: value["imageUrl"],
            isfavorite: value["isfavorite"]));
      });
      _item = loadedproduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addproduct(ProductC product) async {
    final url =
        'https://shop-app-16a74-default-rtdb.firebaseio.com/products.json?auth=$authtoken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isfavorite": product.isfavorite,
          }));

      //final newproduct = ProductC(
      //    id: jsonDecode(response.body)["name"],
      //    title: product.title,
      //    price: product.price,
      //    description: product.description,
      //    imageUrl: product.imageUrl);
      //_item.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(String id, ProductC product) async {
    final prid = _item.indexWhere((element) => element.id == id);

    final url =
        "https://shop-app-16a74-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken";
    await http.patch(Uri.parse(url),
        body: json.encode({
          "title": product.title,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
        }));

    //_item[prid] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-16a74-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken';
    final existingProductIndex = _item.indexWhere((prod) => prod.id == id);
    var existingProduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExeption(message: 'Could not delete product.');
    }
  }
}
