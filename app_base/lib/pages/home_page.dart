import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Leticia lindaaa 123", style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
        
        ),

        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.logout, color:Colors.grey[300],))
        ],
      ),
    );
  }
}
