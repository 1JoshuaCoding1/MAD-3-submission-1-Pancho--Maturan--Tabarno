import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_change_demo/src/enum/enum.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  AuthState state = AuthState.unauthenticated;
  SimulatedAPI api = SimulatedAPI();

  static const String _sessionKey = 'user_session';
  static const String _usernameKey = 'username'; 

  String? _username; 

  String? get username => _username; 

  Future<void> login(String userName, String password) async {
    bool isLoggedIn = await api.login(userName, password);
    if (isLoggedIn) {
      state = AuthState.authenticated;
      _username = userName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, 'authenticated');
      await prefs.setString(_usernameKey, userName);
      print("login works");
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = AuthState.unauthenticated;
    _username = null;
    print("session end");
    notifyListeners();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? session = prefs.getString(_sessionKey);
    if (session != null && session == 'authenticated') {
      state = AuthState.authenticated;
      _username = prefs.getString(_usernameKey);
    } else {
      state = AuthState.unauthenticated;
      _username = null;
    }
    notifyListeners();
  }
}

class SimulatedAPI {
  Map<String, String> users = {"testUser": "12345678ABCabc!"};

  Future<bool> login(String userName, String password) async {
    await Future.delayed(const Duration(seconds: 4));
    if (users[userName] == null) throw Exception("User does not exist");
    if (users[userName] != password) throw Exception("Password does not match!");
    return users[userName] == password;
  }
}
