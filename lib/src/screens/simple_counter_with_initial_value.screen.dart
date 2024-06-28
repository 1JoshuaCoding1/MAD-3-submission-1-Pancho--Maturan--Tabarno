import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterNotifier with ChangeNotifier {
  int counter = 0;

  CounterNotifier() {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  Future<void> increment() async {
    counter = counter + 1;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }
}

class SimpleCounterScreenWithInitialValue extends StatefulWidget {
  static const String route = 'simple-counter';
  static const String path = '/simple-counter';
  static const String name = 'Simple Counter Screen (with initial Value)';

  final int initialValue;
  const SimpleCounterScreenWithInitialValue(
      {super.key, required this.initialValue});

  @override
  State<SimpleCounterScreenWithInitialValue> createState() =>
      _SimpleCounterScreenWithInitialValueState();
}

class _SimpleCounterScreenWithInitialValueState
    extends State<SimpleCounterScreenWithInitialValue> {
  late CounterNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = CounterNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SimpleCounterScreenWithInitialValue.name),
      ),
      body: Column(
        children: [
          ListenableBuilder(
              listenable: notifier,
              builder: (context, _) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'You have pushed the button this many times:',
                      ),
                      Text(
                        '${notifier.counter}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
