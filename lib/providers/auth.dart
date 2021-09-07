import "dart:convert";
import "dart:async";

import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;

class Auth with ChangeNotifier{
String _token;
DateTime _expiryDate;
String _userId;
Timer _authTimer;

bool get isAuth{
  return token != null;
}
 String get token{
  if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
    return _token;
  }
  return null;
 }

 String get userId{
  return _userId;
 }

 Future<void> _authenticate(String email, String password, String urlSegment) async {

  final url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBi3pL8W4Wi4UIpqN1IqKKZUveAkl3wcKQ";
  try{
    final res = await http.post(url, body:json.encode({
      "email": email,
      "password": password,
      "returnSecureToken": true,
    }));

    final resData = json.decode(res.body);
    if(resData["error"] != null){
      throw HttpException(resData["error"]["message"]);
    }
    _token = resData["idToken"];
    _userId = resData["localId"];
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(resData["expiresIn"])));
    _autoLogout();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String userData = json.encode({
      "token": _token,
      "userId": _userId,
      "expiryDate": _expiryDate.toString(),
    });
    prefs.setString("userData", userData);
  }catch(e){
    throw e;
  }
 }

Future<void> signUp(String email, String password) async {
  return _authenticate(email, password, "signUp");
}

Future<void> login(String email, String password) async {
  return _authenticate(email, password, "signInWithPassword");
}

Future<bool> tryAutoLogin() async {
  final prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey("userData")) return false;

  final Map<String, Object> extractData = json.decode(prefs.getString("userData")) as Map<String, Object>;

  final expiryDate = DateTime.parse(extractData["expiryDate"]);
  if(expiryDate.isBefore(DateTime.now())) return false;

  _token = extractData["token"];
  _userId = extractData["userId"];
  _expiryDate = expiryDate;
  notifyListeners();
  _autoLogout();
  return true;
}

Future<void> logout() async {
  _token = null;
  _userId = null;
  _expiryDate = null;
  if(_authTimer != null){
    _authTimer.cancel();
    _authTimer = null;
  }
  notifyListeners();

  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<void> _autoLogout(){
  if(_authTimer != null){
    _authTimer.cancel();
  }
  final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
}
}