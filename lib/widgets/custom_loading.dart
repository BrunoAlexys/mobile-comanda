import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomLoading extends StatelessWidget {
  final String loadingText;

  const CustomLoading({super.key, this.loadingText = 'Carregando...'});

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = Utils.hexToColor(AppColors.primaryColor);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),

          const SizedBox(height: 16),

          Text(
            loadingText,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
