import 'package:app_base/auth/login_or_register.dart';
import 'package:app_base/pages/feed_page.dart';
import 'package:app_base/pages/home_page.dart';
import 'package:app_base/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O StreamBuilder está escutando as mudanças no estado de autenticação do usuário via FirebaseAuth.
// - stream: FirebaseAuth.instance.authStateChanges() é a stream que notifica sempre que o estado de autenticação do usuário muda (login, logout, etc.).
// - builder: Função que constrói o widget com base nos dados da stream. O snapshot contém o estado atual da autenticação.
// O StreamBuilder atualizará o layout automaticamente sempre que houver mudanças no estado de autenticação.

      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
// user está logado
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
