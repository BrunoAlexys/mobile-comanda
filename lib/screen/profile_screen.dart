import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserStore userStore = locator<UserStore>();
  final SecureStorageService secureStorageServicce = locator<SecureStorageService>();

  @override
  void initState() {
    super.initState();
    userStore.loadCurrentUser();
  }

  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Telefone não informado';

    if (phone.contains('(') && phone.contains(')')) {
      return phone;
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.length == 11) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 7)}-${cleanPhone.substring(7)}';
    } else if (cleanPhone.length == 10) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 6)}-${cleanPhone.substring(6)}';
    }

    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Utils.hexToColor(AppColors.primaryColor);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColorGradient: [
          primaryColor,
          Utils.hexToColor(AppColors.secondaryColor),
        ],
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Observer(
                  builder: (_) {
                    if (userStore.isLoading && userStore.user == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userStore.user?.name ?? 'Usuário',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userStore.user?.email ?? 'Email não informado',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Text(
                              'Telefone ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              _formatPhone(userStore.user?.telephone),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Funcionário desde: ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const Text(
                              'Janeiro de 2024',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Column(
                children: [
                  _buildOptionItem(
                    icon: Icons.edit,
                    iconColor: const Color(0xFFE53935),
                    title: 'Editar Perfil',
                    subtitle: 'Alterar informações pessoais',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.alterProfile);
                    },
                  ),
                  const Divider(height: 1, indent: 70, endIndent: 20),
                  _buildOptionItem(
                    icon: Icons.lock,
                    iconColor: const Color(0xFFE53935),
                    title: 'Alterar Senha',
                    subtitle: 'Modificar senha de acesso',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.recoveryPassword);
                    },
                  ),
                  const Divider(height: 1, indent: 70, endIndent: 20),
                  _buildOptionItem(
                    icon: Icons.logout,
                    iconColor: const Color(0xFFE53935),
                    title: 'Sair',
                    subtitle: 'Clique aqui para sair',
                    onTap: () async {
                      await userStore.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomMenu(selectedIndex: 2),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
    );
  }
}