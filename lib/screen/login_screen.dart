import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/enum/biometric_preference.dart';
import 'package:mobile_comanda/service/biometric_service.dart';
import 'package:mobile_comanda/service/secure_storage_service.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_alert.dart';
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
  final UserStore _userStore = locator<UserStore>();
  final _biometricService = locator<BiometricService>();
  final _secureStorageService = locator<SecureStorageService>();

  bool _isBiometricAvailable = false;
  BiometricPreference _biometricPreference = BiometricPreference.notChoosen;

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
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    _isBiometricAvailable = await _biometricService.isBiometricAvailable();
    _biometricPreference = await _secureStorageService.getBiometricPreference();

    if (!mounted) return;

    setState(() {});

    if (_isBiometricAvailable &&
        _biometricPreference == BiometricPreference.enabled) {
      await _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    final isAuthenticated = await _biometricService.authenticate(
      localizedReason: 'Faça login com sua digital ou reconhecimento facial',
    );

    if (!mounted) return;

    if (isAuthenticated) {
      final credentials = await _secureStorageService.getCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null) {
        _emailController.text = email;
        _passwordController.text = password;
        await _login(isBiometricLogin: true);
      }
    }
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('saved_email');
    final bool? rememberMe = prefs.getBool('remember_me');

    if (!mounted) return;

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

  Future<void> _login({bool isBiometricLogin = false}) async {
    // Guardar o context atual antes de operações assíncronas
    final currentContext = context;

    await _saveOrClearCredentials();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _userStore.loginAndFetchAndSetUser(email, password);

    if (!currentContext.mounted) return;

    if (success) {
      if (!isBiometricLogin &&
          _isBiometricAvailable &&
          _biometricPreference == BiometricPreference.notChoosen) {
        await _promptEnableBiometrics();
      } else {
        CustomAlert.success(
          context: currentContext,
          message: 'Login realizado com sucesso!',
        );
        Navigator.of(currentContext).pushReplacementNamed(AppRoutes.home);
      }
    } else {
      CustomAlert.error(
        context: currentContext,
        message: _userStore.errorMessage ?? 'E-mail ou senha incorretos.',
      );
    }
  }

  Future<void> _promptEnableBiometrics() async {
    final currentContext = context;

    if (!currentContext.mounted) return;

    return showDialog<void>(
      context: currentContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Login por Biometria'),
          content: const Text(
            'Deseja habilitar o login rápido com sua digital ou rosto?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                await _secureStorageService.setBiometricPreference(
                  BiometricPreference.disabled,
                );
                await _secureStorageService.clearCredentials();

                if (!currentContext.mounted) return;

                navigator.pop();
                Navigator.of(
                  currentContext,
                ).pushReplacementNamed(AppRoutes.home);
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                await _secureStorageService.setBiometricPreference(
                  BiometricPreference.enabled,
                );
                await _secureStorageService.saveCredentials(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (!currentContext.mounted) return;

                navigator.pop();
                Navigator.of(
                  currentContext,
                ).pushReplacementNamed(AppRoutes.home);
              },
            ),
          ],
        );
      },
    );
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
                        color: Colors.white.withAlpha(3),
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
                          child: Observer(
                            builder: (context) {
                              final isLoading = _userStore.isLoading;
                              final hasText =
                                  _emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty;

                              return Column(
                                children: [
                                  CustomButton(
                                    text: isLoading ? 'Entrando...' : 'Entrar',
                                    isEnabled: !isLoading && hasText,
                                    gradientColors: [
                                      Utils.hexToColor(AppColors.redInitial),
                                      Utils.hexToColor(AppColors.redFinal),
                                    ],
                                    onPressed: () => _login(),
                                  ),

                                  if (_isBiometricAvailable &&
                                      _biometricPreference ==
                                          BiometricPreference.enabled)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.fingerprint,
                                          size: 48,
                                          color: Utils.hexToColor(
                                            AppColors.primaryColor,
                                          ),
                                        ),
                                        onPressed: _authenticateWithBiometrics,
                                        tooltip: 'Entrar com biometria',
                                      ),
                                    ),
                                ],
                              );
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
