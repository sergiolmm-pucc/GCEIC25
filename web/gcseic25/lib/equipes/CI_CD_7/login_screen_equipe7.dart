 import 'package:flutter/material.dart';
 import 'home_screen.dart';

 class LoginScreen extends StatefulWidget {
   @override
   _LoginScreenState createState() => _LoginScreenState();
 }

 class _LoginScreenState extends State<LoginScreen> {
   final TextEditingController _userController = TextEditingController();
   final TextEditingController _passController = TextEditingController();
   final String _fixedUser = 'admin';
   final String _fixedPass = '123456';

   String? _errorText;

   void _login() {
     final user = _userController.text.trim();
     final pass = _passController.text.trim();
     if (user == _fixedUser && pass == _fixedPass) {
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (_) => HomeScreen()),
       );
     } else {
       setState(() {
         _errorText = 'Usuário ou senha inválidos';
       });
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text('Login')),
       body: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             TextField(
               controller: _userController,
               decoration: InputDecoration(labelText: 'Usuário'),
             ),
             SizedBox(height: 16),
             TextField(
               controller: _passController,
               decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
             ),
             SizedBox(height: 16),
             ElevatedButton(onPressed: _login, child: Text('Entrar')),
             if (_errorText != null) ...[
               SizedBox(height: 12),
               Text(
                 _errorText!,
                 style: TextStyle(color: Colors.red),
               ),
             ]
           ],
         ),
       ),
     );
   }
 }
