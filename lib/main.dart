import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/screen/login_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comanda Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
