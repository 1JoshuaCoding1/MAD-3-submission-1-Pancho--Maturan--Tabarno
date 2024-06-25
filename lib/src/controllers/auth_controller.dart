import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:state_change_demo/src/enum/enum.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  AuthState state = AuthState.unauthenticated;
  SimulatedAPI api = SimulatedAPI();
  final _storage = const FlutterSecureStorage();
  static const String _sessionKey = 'user_session';
  static const String _indexKey = 'index_screen_index';


  login(String userName, String password) async {
    bool isLoggedIn = await api.login(userName, password);
    if (isLoggedIn) {
      state = AuthState.authenticated;
      await _storage.write(key: _sessionKey, value: 'authenticated');
      print("login works");
      notifyListeners();
    }
  }

  logout() async {
    await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _indexKey); 
    state = AuthState.unauthenticated;
    notifyListeners();
  }

  Future<void> loadSession() async {
    String? session = await _storage.read(key: _sessionKey);
    if (session != null && session == 'authenticated') {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
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
