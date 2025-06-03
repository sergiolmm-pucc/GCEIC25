import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/CI_CD_6/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String? errorMessage;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  late AnimationController _waveController;
  late AnimationController _formController;
  late AnimationController _shakeController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_waveController);
    
    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _formAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _formController,
          curve: Curves.easeOutCubic,
        ));
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(
          parent: _shakeController,
          curve: Curves.elasticIn,
        ));
    
    _waveController.repeat();
    _formController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _formController.dispose();
    _shakeController.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    // Simular delay de autenticação
    await Future.delayed(const Duration(milliseconds: 1500));

    if (_email.text == "admin@email.com" && _senha.text == "123456") {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        errorMessage = "Email ou senha inválidos";
      });
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: Listenable.merge([_waveAnimation, _formAnimation, _shakeAnimation]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 2.0,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF0F0F0F),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background animated elements
                ...List.generate(5, (index) {
                  return Positioned(
                    top: 80 + (index * 140) + math.sin(_waveAnimation.value + index) * 30,
                    left: 20 + (index * 100) + math.cos(_waveAnimation.value + index) * 25,
                    child: Container(
                      width: 70 + (index * 10),
                      height: 70 + (index * 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFE97A12).withOpacity(0.06 + index * 0.01),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 
                                   MediaQuery.of(context).padding.top - 
                                   MediaQuery.of(context).padding.bottom,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const SizedBox(height: 40),
                          
                          // Header with logo
                          Transform.translate(
                            offset: Offset(0, (1 - _formAnimation.value) * -50),
                            child: Opacity(
                              opacity: _formAnimation.value,
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFE97A12),
                                          Color(0xFFFF8C42),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFE97A12).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.calculate,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Bem-vindo!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Entre para acessar o Calculo ETEC',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 50),
                          
                          // Login form
                          Transform.translate(
                            offset: Offset(
                              math.sin(_shakeAnimation.value * math.pi * 8) * 5,
                              (1 - _formAnimation.value) * 50,
                            ),
                            child: Opacity(
                              opacity: _formAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white.withOpacity(0.05),
                                  border: Border.all(
                                    color: const Color(0xFFE97A12).withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Email field
                                      _buildTextField(
                                        controller: _email,
                                        label: 'Email',
                                        icon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, insira seu email';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Email inválido';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      // Password field
                                      _buildTextField(
                                        controller: _senha,
                                        label: 'Senha',
                                        icon: Icons.lock_outline,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, insira sua senha';
                                          }
                                          if (value.length < 6) {
                                            return 'Senha deve ter pelo menos 6 caracteres';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      const SizedBox(height: 32),
                                      
                                      // Login button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _isLoading ? null : _login,
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                gradient: LinearGradient(
                                                  colors: _isLoading 
                                                      ? [
                                                          const Color(0xFFE97A12).withOpacity(0.5),
                                                          const Color(0xFFFF8C42).withOpacity(0.5),
                                                        ]
                                                      : [
                                                          const Color(0xFFE97A12),
                                                          const Color(0xFFFF8C42),
                                                        ],
                                                ),
                                                boxShadow: _isLoading 
                                                    ? []
                                                    : [
                                                        BoxShadow(
                                                          color: const Color(0xFFE97A12).withOpacity(0.4),
                                                          blurRadius: 15,
                                                          offset: const Offset(0, 5),
                                                        ),
                                                      ],
                                              ),
                                              child: Center(
                                                child: _isLoading
                                                    ? const SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                        ),
                                                      )
                                                    : const Text(
                                                        'Entrar',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      // Error message
                                      if (errorMessage != null) ...[
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.red.withOpacity(0.1),
                                            border: Border.all(
                                              color: Colors.red.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade300,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  errorMessage!,
                                                  style: TextStyle(
                                                    color: Colors.red.shade300,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Demo credentials info
                          Transform.translate(
                            offset: Offset(0, (1 - _formAnimation.value) * 30),
                            child: Opacity(
                              opacity: _formAnimation.value * 0.8,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white.withOpacity(0.02),
                                  border: Border.all(
                                    color: const Color(0xFFE97A12).withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: const Color(0xFFE97A12).withOpacity(0.7),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Credenciais de demonstração:',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Email: admin@email.com\nSenha: 123456',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                      ),
                                      textAlign: TextAlign.center,
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFE97A12).withOpacity(0.7),
          size: 20,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE97A12),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.red.shade300,
          fontSize: 12,
        ),
      ),
    );
  }
}