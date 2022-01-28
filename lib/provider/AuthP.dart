import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shahroo_51/provider/Http_exception.dart';

class AuthP with ChangeNotifier {
  String? _token;
  DateTime? _expiredate;
  String? _userid;

String? get userid{
  return _userid;
}
bool get isAuth{
return token!=null;
}
String? get token{
  if(_expiredate!=null && _token!=null && _expiredate!.isAfter(DateTime.now())){
return _token;
  }
  return null;
}


  Future<void> _authenticate(
      String email, String password, String Urlboth) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$Urlboth?key=AIzaSyAd9Gqk_DePiiLnHLbXQS2BbxsYcHUB9ds";

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
          final responsemassage= jsonDecode(response.body);
          
          if(responsemassage["error"] !=null){
            throw HttpExeption(message: responsemassage["error"]["message"]);
          }
          _token=responsemassage["idToken"];
          _expiredate=DateTime.now().add(Duration(seconds: int.parse(responsemassage["expiresIn"])));
          _userid=responsemassage["localId"];
          notifyListeners();
          
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
