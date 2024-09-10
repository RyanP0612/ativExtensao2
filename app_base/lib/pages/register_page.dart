import 'package:app_base/components/button.dart';
import 'package:app_base/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
Map<String, String> errorMessages = {
  'user-not-found': 'Nenhum usuário encontrado com este e-mail.',
  'wrong-password': 'Senha incorreta.',
  'email-already-in-use': 'Este e-mail já está em uso.',
  'invalid-email': 'Email inválido.',
  'weak-password': 'A senha deve ter pelo menos 6 caracteres.',
  // Adicione mais traduções conforme necessário
};
  // sign user up
  void signUp() async{
      // circulo de carregamento
    showDialog(context: context, builder: (context)=> const Center(child: CircularProgressIndicator(),));

    if(passwordTextController.text != confirmPasswordTextController.text){
      // pop loading
      Navigator.pop(context);
      // show error
      displayMessage(context, "Senhas diferentes", false);
      return;
    }

    // try criar usuario
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
      // if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e){
   print(e.code);
    Navigator.pop(context); 
      displayMessage(context, e.code, true);
    }

  }

  
void displayMessage(BuildContext context, String errorCode, bool traduzir) {
  if(traduzir){
String message = errorMessages[errorCode] ?? 'Ocorreu um erro desconhecido.';   
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
      
    
     
    ),
  ); 
  }
  else{
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(errorCode),
      
    
     
    ),
  );
  
}
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
                  "Vamos criar sua conta!",
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
                  height: 10,
                ),
                // confirmar senha
                MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirmar senha',
                    obscureText: true),
                const SizedBox(
                  height: 25,
                ),
                // butao de logar
                MyButton(onTap: signUp, text: "Logar"),

                const SizedBox(
                  height: 25,
                ),
                // página de registro!!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já tem uma conta?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Entre agora!",
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
