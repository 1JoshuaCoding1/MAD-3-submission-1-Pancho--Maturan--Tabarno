import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:state_change_demo/src/screens/key_example.dart';
import 'package:state_change_demo/src/screens/no_key_example.dart';
import 'package:state_change_demo/src/screens/simple_counter.screen.dart';
import 'package:state_change_demo/src/screens/simple_counter_with_initial_value.screen.dart';
import 'package:state_change_demo/src/screens/stfulP_stfulP.dart';
import 'package:state_change_demo/src/screens/stfulP_stlssC.dart';

import '../controllers/auth_controller.dart';

class IndexScreen extends StatefulWidget {
  static const String route = '/';
  static const String name = 'Index Screen';

  const IndexScreen({Key? key}) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late int _selectedIndex;
  final _storage = FlutterSecureStorage();
  static const String _indexKey = 'index_screen_index';

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
    AuthController.instance.addListener(_handleAuthChange); 
  }

  @override
  void dispose() {
    AuthController.instance.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _handleAuthChange() {
    if (!mounted) return;
    setState(() {
    });
  }

  void _loadSelectedIndex() async {
    String? indexValue = await _storage.read(key: _indexKey);
    if (indexValue != null) {
      setState(() {
        _selectedIndex = int.parse(indexValue);
      });
    } else {
      _selectedIndex = 0;
    }
  }

  Future<void> _saveSelectedIndex(int index) async {
    _selectedIndex = index;
    await _storage.write(key: _indexKey, value: '$_selectedIndex');
  }

  Future<void> _clearSessionData() async {
    await _storage.delete(key: _indexKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(IndexScreen.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(0);
                    GoRouter.of(context).push(SimpleCounterScreen.path);
                  },
                  title: const Text(SimpleCounterScreen.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(1);
                    GoRouter.of(context).push(SimpleCounterScreenWithInitialValue.path);
                  },
                  title: const Text(SimpleCounterScreenWithInitialValue.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(2);
                    GoRouter.of(context).push(StatefulParent.path);
                  },
                  title: const Text(StatefulParent.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(3);
                    GoRouter.of(context).push(StatefulParentAndChild.path);
                  },
                  title: const Text(StatefulParentAndChild.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(4);
                    GoRouter.of(context).push(KeyExample.path);
                  },
                  title: const Text(KeyExample.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(5);
                    GoRouter.of(context).push(NoKeyExample.path);
                  },
                  title: const Text(NoKeyExample.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
