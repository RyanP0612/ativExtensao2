import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          // foto de perfil
          Icon(
            Icons.person,
            size: 72,
          ),
          const SizedBox(
            height: 10,
          ),
          // user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),

          // user detalhes
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "Meus Detalhes",
              style: TextStyle(color: Colors.grey[600]),
            ),
          )

          // username
        ],
      ),
    );
  }
}
