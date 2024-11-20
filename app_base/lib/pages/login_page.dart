import 'package:app_base/components/button.dart';
import 'package:app_base/components/text_field.dart';
import 'package:app_base/themes/theme.dart';
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
      backgroundColor: AppTheme.cor1, // Usando a cor 'cor1' para o fundo (pêssego claro)

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "assets/images/logoProject.png",
                  height: 150,
                  // color: AppTheme.cor4, // Usando a cor 'cor4' para o ícone (verde profundo)
                ),

                const SizedBox(
                  height: 50,
                ),
                // Texto de boas-vindas
                Text(
                  "Bem-vindo de volta, sentimos sua falta!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: AppTheme.cor5, // Usando a cor 'cor4' para o texto
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // Email TextField
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                // Senha TextField
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Senha',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                // Botão de login
                MyButton(
                  onTap: signIn,
                  text: "Entrar",
                  buttonColor: AppTheme.cor3, // Usando a cor 'cor3' para o botão (verde suave)
                ),

                const SizedBox(
                  height: 25,
                ),
                // Texto para a página de registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não é um membro?",
                      style: TextStyle(color: AppTheme.cor5), // Usando 'cor5' para o texto secundário (marrom suave)
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Se inscreva agora!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: AppTheme.cor4, // Usando 'cor4' para o texto de ação (verde profundo)
                        ),
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
