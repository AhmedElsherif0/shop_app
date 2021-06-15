import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utilities/http_exceptions.dart';
import 'package:shop_app/utilities/constants.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireData;
  Timer _authTimer;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String get authToken {
    if (_expireData != null &&
        _expireData.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth => authToken != null;

  String get userId => _userId;

  Future<void> logOut() async {
    _expireData = null;
    _userId = null;
    _token = null;
    notifyListeners();
    final pref = await _prefs;
    pref.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _autoLogout = _expireData.difference(DateTime.now()).inMilliseconds;
    _authTimer = Timer(Duration(seconds: _autoLogout), logOut);
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse('$baseAuthUrl/v1/accounts:$urlSegment?key=$apiKey');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpExceptions(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireData = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();

      final userData = json.encode({
        'token': _token,
        'usedId': _userId,
        'expiryDate': _expireData.toIso8601String()
      });
      final pref = await _prefs;
      pref.setString('userData', userData);
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<bool> tryAutoLogin() async {
    final pref = await _prefs;
    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireData = expiryData;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIN(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
