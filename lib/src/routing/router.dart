import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/enum/enum.dart';
import 'package:state_change_demo/src/screens/auth/login.screen.dart';
import 'package:state_change_demo/src/screens/home/home.screen.dart';
import 'package:state_change_demo/src/screens/home/wrapper.dart';
import 'package:state_change_demo/src/screens/index.screen.dart';
import 'package:state_change_demo/src/screens/key_example.dart';
import 'package:state_change_demo/src/screens/no_key_example.dart';
import 'package:state_change_demo/src/screens/simple_counter.screen.dart';
import 'package:state_change_demo/src/screens/simple_counter_with_initial_value.screen.dart';
import 'package:state_change_demo/src/screens/stfulP_stfulP.dart';
import 'package:state_change_demo/src/screens/stfulP_stlssC.dart';

class GlobalRouter {
  static void initialize() {
    GetIt.instance
        .registerSingletonAsync<GlobalRouter>(() => GlobalRouter.create());
  }

  static Future<GlobalRouter> get instance =>
      GetIt.instance.getAsync<GlobalRouter>();

  static Future<GlobalRouter> get I => GetIt.instance.getAsync<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  GlobalRouter._();

  static Future<GlobalRouter> create() async {
    final instance = GlobalRouter._();
    await instance._initialize();
    return instance;
  }

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) async {
    // Check if the user is authenticated
    if (AuthController.instance.state == AuthState.authenticated) {
      // If the current route is not the login screen, do nothing (return null to indicate no redirection)
      if (state.matchedLocation != LoginScreen.route) {
        return null;
      }
      // If the user is authenticated and on the login screen, redirect to the home screen
      return HomeScreen.route;
    } else {
      // If the user is not authenticated, redirect to the login screen
      return LoginScreen.route;
    }
  }

  Future<void> _initialize() async {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();

    String initialLocation = await getInitialRoute();
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation,
      redirect: handleRedirect,
      refreshListenable: AuthController.instance, // The router listen to changes in the auth state
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: LoginScreen.route,
          name: LoginScreen.name,
          builder: (context, _) => const LoginScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: HomeScreen.route,
              name: HomeScreen.name,
              builder: (context, _) => const HomeScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: "/index",
              name: "Wrapped Index",
              builder: (context, _) => const IndexScreen(),
            ),
          ],
          builder: (context, state, child) => HomeWrapper(child: child),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: IndexScreen.route,
          name: IndexScreen.name,
          builder: (context, _) => const IndexScreen(),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: SimpleCounterScreen.route,
              name: SimpleCounterScreen.name,
              builder: (context, _) => const SimpleCounterScreen(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: SimpleCounterScreenWithInitialValue.route,
              name: SimpleCounterScreenWithInitialValue.name,
              builder: (context, _) =>
                  const SimpleCounterScreenWithInitialValue(initialValue: 10),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: StatefulParent.route,
              name: StatefulParent.name,
              builder: (context, _) => const StatefulParent(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: StatefulParentAndChild.route,
              name: StatefulParentAndChild.name,
              builder: (context, _) => const StatefulParentAndChild(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: KeyExample.route,
              name: KeyExample.name,
              builder: (context, _) => const KeyExample(),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: NoKeyExample.route,
              name: NoKeyExample.name,
              builder: (context, _) => const NoKeyExample(),
            ),
          ],
        ),
      ],
      observers: [
        GoRouterObserver((location) {
          _saveCurrentRoute(location);
        }),
      ],
    );
  }

  Future<void> _saveCurrentRoute(String location) async {
    await _storage.write(key: 'lastRoute', value: location);
  }

  Future<String?> _getLastRoute() async {
    return await _storage.read(key: 'lastRoute');
  }

  Future<String> getInitialRoute() async {
    String? lastRoute = await _getLastRoute();
    return lastRoute ?? HomeScreen.route;
  }
}

class GoRouterObserver extends NavigatorObserver {
  final void Function(String location) onChange;

  GoRouterObserver(this.onChange);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onChange(route.settings.name ?? '');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onChange(previousRoute?.settings.name ?? '');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    onChange(previousRoute?.settings.name ?? '');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onChange(newRoute?.settings.name ?? '');
  }
}
