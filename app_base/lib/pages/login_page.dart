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

Map<String, String> errorMessages = {
  'user-not-found': 'Nenhum usuário encontrado com este e-mail.',
  'wrong-password': 'Senha incorreta.',
  'email-already-in-use': 'Este e-mail já está em uso.',
  'invalid-email': 'Email inválido.',
  'weak-password': 'A senha deve ter pelo menos 6 caracteres.',
  // Adicione mais traduções conforme necessário
};

void signIn() async {
  // circulo de carregamento
  showDialog(context: context, builder: (context)=> const Center(child: CircularProgressIndicator(),));



  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailTextController.text,
      password: passwordTextController.text,
    );
    
// tirar o carregamento pop
if(context.mounted) Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    print(e.code);
    Navigator.pop(context); 

    // tirar o carregamento automaticamente
    displayMessage(context, e.code);

    

    
  }
}

void displayMessage(BuildContext context, String errorCode) {
  String message = errorMessages[errorCode] ?? 'Ocorreu um erro desconhecido.';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
      
    
     
    ),
  );
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
