import 'package:app_base/components/button.dart';
import 'package:app_base/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Future<void> signIn() async {
await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // Colors.grey[300] representa uma tonalidade de cinza claro da paleta de cores do Material Design.

      body: SafeArea(
        // O SafeArea ajusta o layout para que o conteúdo não seja sobreposto por barras de status, notches ou bordas arredondadas do dispositivo.

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(
                  height: 50,
                ),
                //bem vindo de volta
                Text(
                  "Bem-vindo de volta, sentimos sua falta!",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02),
                ),

                const SizedBox(
                  height: 25,
                ),

                // email textfield
                MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                // senha textfield
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Senha',
                    obscureText: true),
                const SizedBox(
                  height: 25,
                ),
                // butao de logar
                MyButton(onTap: signIn, text: "Entrar"),

                const SizedBox(
                  height: 25,
                ),
                // página de registro!!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não é um membro?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Se inscreva agora!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
