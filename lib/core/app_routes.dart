import 'package:flutter/material.dart';
import 'package:mobile_comanda/screen/home_screen.dart';
import 'package:mobile_comanda/screen/login_screen.dart';
import 'package:mobile_comanda/screen/profile_screen.dart';
import 'package:mobile_comanda/screen/recoveryPassword_screen.dart';
import 'package:mobile_comanda/screen/alterProfile_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String pedidos = '/pedidos';
  static const String recoveryPassword = '/recoveryPassword';
  static const String alterProfile = '/alterProfile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case recoveryPassword:
        return MaterialPageRoute(builder: (_) => const RecoveryPasswordScreen());
      case alterProfile:
        return MaterialPageRoute(builder: (_) => const AlterProfileScreen());
      case pedidos:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Pedidos'))));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}