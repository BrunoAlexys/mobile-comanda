import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Aqui está a chamada para o seu CustomAppBar
      appBar: CustomAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meu Perfil', // 2. Título atualizado para a tela
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // 3. Usando o mesmo gradiente da HomeScreen
        backgroundColorGradient: [
          Utils.hexToColor(AppColors.primaryColor),
          Utils.hexToColor(AppColors.secondaryColor),
        ],
        actions: [
          // 4. Sugestão: Mudei o ícone para "Configurações", que faz mais sentido no perfil
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                print('Botão de Configurações pressionado!');
              },
              icon: Icon(
                Icons.settings_outlined, // Ícone de Configurações
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
        // 5. Mantendo o padrão da HomeScreen (sem botão de voltar)
        automaticallyImplyLeading: false,
      ),

      // 6. Corpo da tela (você pode construir seu conteúdo aqui)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_pin, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Conteúdo da Tela de Perfil',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),

      // 7. Incluindo o menu de navegação inferior, assim como na HomeScreen
      bottomNavigationBar: CustomMenu(),
    );
  }
}