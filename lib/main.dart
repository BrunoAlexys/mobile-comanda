import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';
import 'package:mobile_comanda/widgets/custom_input.dart';

void main() {
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
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
            orderTotal: 0,
              text: "Avançar",
              onPressed: () {
              print('Botão foi pressionado!');
              },
              icon: Image.asset(AppIcons.send, width: 24 ,),
              borderRadius: 8,
              gradientColors: const[
               AppColors.redInicial,
                AppColors.redFinal,
              ],
            )
          ),
        ),
      ),
    );
  }
}
