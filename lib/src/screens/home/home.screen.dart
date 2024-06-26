import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final _storage = const FlutterSecureStorage();
  static const String _counterKey = 'home_screen_counter';
  String? _username;


  @override
  void initState() {
    super.initState();
    _loadCounter();
    _loadUsername();
  }

    void _loadUsername() {
    var user = AuthController.instance.username;
    if (user != null) {
      setState(() {
        _username = user;
      });
    }
  }

  void _loadCounter() async {
    String? counterValue = await _storage.read(key: _counterKey);
    if (counterValue != null) {
      setState(() {
        _counter = int.parse(counterValue);
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounter();
  }

  Future<void> _saveCounter() async {
    await _storage.write(key: _counterKey, value: '$_counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomeScreen.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthController.I.logout();
              _storage.delete(key: _counterKey);  
                         },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_username != null)
              Text(
                'Logged in as: $_username',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}