import 'package:flutter/material.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/routing/router.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthController.initialize();
  await AuthController.I.loadSession();

  GlobalRouter.initialize();
  await GetIt.instance.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GlobalRouter>(
      future: GlobalRouter.I,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: snapshot.data!.router,
          );
        }
        return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
      },
    );
  }
}