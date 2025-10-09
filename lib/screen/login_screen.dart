import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';
import 'package:mobile_comanda/widgets/custom_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isChecked = false;
  final UserStore _userStore = GetIt.I<UserStore>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('saved_email');
    final bool? rememberMe = prefs.getBool('remember_me');

    if (rememberMe == true && email != null) {
      setState(() {
        _emailController.text = email;
        isChecked = true;
      });
    }
  }

  Future<void> _saveOrClearCredentials() async {
    if (isChecked) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setBool('remember_me', true);
    }
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('remember_me');
  }

  Future<void> _login() async {
    _userStore.isLoading = true;
    await _saveOrClearCredentials();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _userStore.loginAndFetchAndSetUser(email, password);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      _userStore.isLoading = false;
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_userStore.errorMessage ?? 'Erro ao fazer login.'),
        ),
      );
      _userStore.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Utils.hexToColor(AppColors.primaryColor),
                      Utils.hexToColor(AppColors.secondaryColor),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bem-vindo de volta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Entre em sua conta para continuar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: CustomInput(
                            labelText: 'E-mail',
                            hintText: 'Digite seu e-mail',
                            controller: _emailController,
                            suffixIcon: Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomInput(
                            labelText: 'Senha',
                            hintText: 'Digite sua senha',
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: Icon(Icons.lock_outline),
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    side: BorderSide(
                                      color: Utils.hexToColor(
                                        AppColors.grayColor,
                                      ),
                                    ),
                                    fillColor:
                                        WidgetStateProperty.resolveWith<Color?>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                              WidgetState.disabled,
                                            )) {
                                              return Utils.hexToColor(
                                                AppColors.grayColor,
                                              );
                                            }
                                            return isChecked
                                                ? Utils.hexToColor(
                                                    AppColors.grayColor,
                                                  )
                                                : Colors.white;
                                          },
                                        ),
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isChecked = newValue!;
                                      });
                                      if (!isChecked) {
                                        _clearCredentials();
                                      }
                                    },
                                  ),
                                  Text(
                                    'Lembrar-me',
                                    style: TextStyle(
                                      color: Utils.hexToColor(
                                        AppColors.grayColor,
                                      ),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Esqueceu a senha?',
                                  style: TextStyle(
                                    color: Utils.hexToColor(
                                      AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 40,
                            left: 20,
                            right: 20,
                          ),
                          child: CustomButton(
                            text: _userStore.isLoading
                                ? 'Entrando...'
                                : 'Entrar',
                            isEnabled:
                                _emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty
                                ? true
                                : false,
                            gradientColors: [
                              Utils.hexToColor(AppColors.redInitial),
                              Utils.hexToColor(AppColors.redFinal),
                            ],
                            onPressed: () {
                              _login();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
