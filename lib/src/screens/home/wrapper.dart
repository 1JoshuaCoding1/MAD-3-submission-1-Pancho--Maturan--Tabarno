import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_change_demo/src/screens/home/home.screen.dart';
import '../../routing/router.dart';

class HomeWrapper extends StatefulWidget {
  final Widget? child;
  const HomeWrapper({super.key, this.child});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int index = 0;
  List<String> routes = [HomeScreen.route, "/index"];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GlobalRouter>(
      future: GlobalRouter.I,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return _buildScaffold(snapshot.data!);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildScaffold(GlobalRouter router) {
    return Scaffold(
      body: widget.child ?? const Placeholder(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
            router.router.go(routes[i]);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Index"),
        ],
      ),
    );
  }
}