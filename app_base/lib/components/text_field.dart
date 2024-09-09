import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    // TextField utilizado para entrada de texto, com as seguintes características:
// - controller: controla o texto inserido no campo.
// - obscureText: se verdadeiro, oculta o texto (útil para senhas).
// - decoration: personaliza a aparência do campo, aqui utilizando InputDecoration para configurar a borda.
// - enabledBorder: define uma borda personalizada com cor branca quando o campo está habilitado.

    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }
}
