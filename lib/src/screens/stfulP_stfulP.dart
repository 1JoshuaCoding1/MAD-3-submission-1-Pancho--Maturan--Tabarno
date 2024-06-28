import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatefulParentAndChild extends StatefulWidget {
  static const String route = 'stateful-parent-and-child';
  static const String path = '/stateful-parent-and-child';
  static const String name = 'Stateful Parent and Child';

  const StatefulParentAndChild({super.key});

  @override
  State<StatefulParentAndChild> createState() => _StatefulParentAndChildState();
}

class _StatefulParentAndChildState extends State<StatefulParentAndChild> {
  int _parentValue = 0;
  num newV = 0;

  @override
  void initState() {
    super.initState();
    _loadParentValue();
  }

  _loadParentValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _parentValue = prefs.getInt('parentValue') ?? 0;
      newV = prefs.getDouble('newV') ?? 0;
    });
  }

  _saveParentValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('parentValue', _parentValue);
    await prefs.setDouble('newV', newV.toDouble());
  }

  multiply() {
    _parentValue += 1;
    double z = (_parentValue++ * 4 * 2).toDouble();
    setState(() {
      newV = z;
    });
    _saveParentValue();
    print(newV);
  }

  delayedIncrement() async {
    await Future.delayed(const Duration(seconds: 10));
    print("Async finished");
    if (mounted) {
      setState(() {
        newV = 9999;
      });
      _saveParentValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Parent and Child'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Parent Value: $newV'),
            StatefulChild(),
            ElevatedButton(
              onPressed: multiply,
              child: const Text('Increment Parent'),
            ),
          ],
        ),
      ),
    );
  }
}

class StatefulChild extends StatefulWidget {
  const StatefulChild({super.key});

  @override
  State<StatefulChild> createState() => _StatefulChildState();
}

class _StatefulChildState extends State<StatefulChild> {
  int _childValue = 0;

  @override
  void initState() {
    super.initState();
    _loadChildValue();
  }

  _loadChildValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _childValue = prefs.getInt('childValue') ?? 0;
    });
  }

  _saveChildValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('childValue', _childValue);
  }

  void _incrementChild() {
    setState(() {
      _childValue++;
    });
    _saveChildValue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Child Value: $_childValue'),
        ElevatedButton(
          onPressed: _incrementChild,
          child: const Text('Increment Child'),
        ),
      ],
    );
  }
}
