import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    String? counterValue = await _storage.read(key: _counterKey);
    if (counterValue != null) {
      setState(() {
        _counter = int.parse(counterValue);
      });
    }
  }

  Future<void> _saveCounter() async {
    await _storage.write(key: _counterKey, value: _counter.toString());
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
