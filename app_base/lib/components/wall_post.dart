import 'package:flutter/material.dart';

class LeticiaLindaPost extends StatelessWidget {
final String message;
final String user;


  const LeticiaLindaPost({super.key, required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(user),
        Text(message)
      ],
    );
  }
}