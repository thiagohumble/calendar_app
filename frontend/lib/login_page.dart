import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  String status = "";

  Future<void> login() async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final idToken = await userCredential.user!.getIdToken();
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/user/profile'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      setState(() {
        status = response.body;
      });
    } catch (e) {
      setState(() {
        status = 'Erro: $e';
      });
    }
  }

  Future<void> register() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        status = 'Conta criada com sucesso!';
      });
    } catch (e) {
      setState(() {
        status = 'Erro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'E-mail')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: login, child: const Text('Login')),
            TextButton(onPressed: register, child: const Text('Criar conta')),
            const SizedBox(height: 24),
            Text(status),
          ],
        ),
      ),
    );
  }
}
