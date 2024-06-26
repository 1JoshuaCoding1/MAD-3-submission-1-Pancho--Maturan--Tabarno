import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    setState(() {});
  }

  void _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    int? indexValue = prefs.getInt(_indexKey);
    if (indexValue != null) {
      setState(() {
        _selectedIndex = indexValue;
      });
    } else {
      _selectedIndex = 0;
    }
  }

  Future<void> _saveSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = index;
    });
    await prefs.setInt(_indexKey, _selectedIndex);
  }

  Future<void> _clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_indexKey);
  }

  void _logout() async {
    await AuthController.instance.logout();
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(IndexScreen.name),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
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
                    GoRouter.of(context).push(SimpleCounterScreen.route);
                  },
                  title: const Text(SimpleCounterScreen.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(1);
                    GoRouter.of(context).push(SimpleCounterScreenWithInitialValue.route);
                  },
                  title: const Text(SimpleCounterScreenWithInitialValue.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(2);
                    GoRouter.of(context).push(StatefulParent.route);
                  },
                  title: const Text(StatefulParent.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(3);
                    GoRouter.of(context).push(StatefulParentAndChild.route);
                  },
                  title: const Text(StatefulParentAndChild.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(4);
                    GoRouter.of(context).push(KeyExample.route);
                  },
                  title: const Text(KeyExample.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () async {
                    await _saveSelectedIndex(5);
                    GoRouter.of(context).push(NoKeyExample.route);
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
