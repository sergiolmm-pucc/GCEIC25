import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/user_data.dart';
import 'MainMenu.dart';
import 'splash_screen.dart';

void main() => runApp(SolarLoginApp());

class SolarLoginApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/forgot',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => CreateAccountScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final username = _userController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final resp = await http.post(
        Uri.parse('http://localhost:3000/solar-panel/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (resp.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainMenu()),
        );
      } else {
        final msg = jsonDecode(resp.body)['message'] ?? 'Erro ao fazer login';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFF2196F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 60, color: Color(0xFF7B1FA2)),
                    SizedBox(height: 16),
                    Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B1FA2),
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: _userController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Color(0xFF2196F3)),
                        labelText: 'Usuário',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF2196F3)),
                        labelText: 'Senha',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Entrar', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _consumoController    = TextEditingController();
  final _horasSolController   = TextEditingController();
  final _tarifaController     = TextEditingController();
  final _precoContaController = TextEditingController();
  final _espacoController     = TextEditingController();

  bool _loading = false;
  Map<String, dynamic>? _resultado;

  Future<void> calcularSistema() async {
    // validação simples
    if (_consumoController.text.isEmpty ||
        _horasSolController.text.isEmpty ||
        _tarifaController.text.isEmpty ||
        _precoContaController.text.isEmpty ||
        _espacoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _resultado = null;
    });

    try {
      final url = Uri.parse('http://localhost:3000/solar-panel'); 
      final body = {
        'consumo_mensal_kwh':    double.parse(_consumoController.text),
        'horas_sol_dia':         double.parse(_horasSolController.text),
        'tarifa_energia':        double.parse(_tarifaController.text),
        'preco_medio_conta':     double.parse(_precoContaController.text),
        'espaco_disponivel_m2':  double.parse(_espacoController.text),
      };

      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (resp.statusCode == 200) {
        setState(() => _resultado = jsonDecode(resp.body));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao calcular: ${resp.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _consumoController.dispose();
    _horasSolController.dispose();
    _tarifaController.dispose();
    _precoContaController.dispose();
    _espacoController.dispose();
    super.dispose();
  }

  Widget _buildResultado() {
    if (_resultado == null) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text('Resultados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Potência necessária: ${_resultado!['potencia_necessaria_kwp']} kWp'),
        Text('Quantidade de painéis: ${_resultado!['quantidade_paineis']}'),
        Text('Área necessária: ${_resultado!['area_necessaria_m2']} m²'),
        Text('Espaço disponível: ${_resultado!['espaco_disponivel_m2']} m²'),
        Text('Espaço suficiente? ${_resultado!['espaco_suficiente'] ? 'Sim' : 'Não'}'),
        if (!_resultado!['espaco_suficiente'])
          Text('Área extra necessária: ${_resultado!['area_extra_necessaria_m2']} m²'),
        Text('Custo total: R\$ ${_resultado!['custo_total_r\$']}'),
        Text('Payback: ${_resultado!['payback_anos']}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulador Solar'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _consumoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Consumo mensal (kWh)'),
            ),
            TextField(
              controller: _horasSolController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Horas de sol por dia'),
            ),
            TextField(
              controller: _tarifaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Tarifa de energia (R\$/kWh)'),
            ),
            TextField(
              controller: _precoContaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Preço médio da conta (R\$)'),
            ),
            TextField(
              controller: _espacoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Espaço disponível (m²)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : calcularSistema,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Calcular'),
            ),
            const SizedBox(height: 20),
            _buildResultado(),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = UserData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
        backgroundColor: Color(0xFFFFB703),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(user.username ?? 'Usuário', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(user.email ?? 'email@email.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  void _mostrarPopup(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o popup
              context.go('/'); // Redireciona para login
            },
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _enviarRecuperacao() {
    if (_emailController.text.contains('@') && _emailController.text.contains('.com')) {
      _mostrarPopup('Instruções enviadas para ${_emailController.text}');
    } else {
      _mostrarPopup('Digite um e-mail válido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esqueci minha senha'),
        backgroundColor: Color(0xFFFFB703),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Informe seu e-mail para recuperar a senha:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enviarRecuperacao,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  void _mostrarPopup(String mensagem, {bool sucesso = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o popup
              if (sucesso) context.go('/login'); // Redireciona para login se sucesso
            },
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _criarConta() {
    if (_userController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty) {
      _mostrarPopup('Preencha todos os campos');
    } else if (!_emailController.text.contains('@') && !_emailController.text.contains('.com')) {
      _mostrarPopup('E-mail inválido');
    } else if (_senhaController.text != _confirmarSenhaController.text) {
      _mostrarPopup('As senhas não coincidem');
    } else {
      // Salva os dados do usuário
      UserData().username = _userController.text;
      UserData().email = _emailController.text;
      _mostrarPopup('Conta criada com sucesso!', sucesso: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta'),
        backgroundColor: Color(0xFFFFB703),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Preencha os dados para criar sua conta:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmarSenhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _criarConta,
              child: Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}