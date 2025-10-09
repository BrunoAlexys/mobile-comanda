import 'package:flutter/material.dart';
import 'package:mobile_comanda/screen/home_screen.dart';
import 'package:mobile_comanda/screen/login_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
