import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleCounterScreen extends StatefulWidget {
  static const String route = 'simple-counter-2';
  static const String path = '/simple-counter-2';
  static const String name = 'Simple Counter Screen';

  const SimpleCounterScreen({Key? key}) : super(key: key);

  @override
  State<SimpleCounterScreen> createState() => _SimpleCounterScreenState();
}

class _SimpleCounterScreenState extends State<SimpleCounterScreen> {
  int _counter = 0;
  static const String _counterKey = 'simple_counter_value';

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final counterValue = prefs.getInt(_counterKey);
    if (counterValue != null) {
      setState(() {
        _counter = counterValue;
      });
    }
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, _counter);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SimpleCounterScreen.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.bodyMedium,
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
