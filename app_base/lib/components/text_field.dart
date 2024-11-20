import 'package:app_base/themes/theme.dart';
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
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.cor6),
          ),

          // fillColor: AppTheme.cor5,
          filled: false,
          hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }
}
