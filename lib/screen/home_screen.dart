import 'package:flutter/material.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userStore = locator<UserStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Welcome to the Home Screen!')),
          SizedBox(height: 20),
          CustomButton(text: 'Sair', onPressed: () => _userStore.logout()),
        ],
      ),
    );
  }
}
