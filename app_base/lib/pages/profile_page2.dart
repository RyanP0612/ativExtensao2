import 'dart:io';

import 'package:app_base/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage2 extends StatefulWidget {
  final String email;

  const ProfilePage2({super.key, required this.email});

  @override
  State<ProfilePage2> createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> {
// Pega o usuário atual autenticado usando o Firebase Authentication
  final currentUser = FirebaseAuth.instance.currentUser!;
  String username = '';
  TextEditingController _textEditingController = TextEditingController();

// Referência para a coleção "Users" no Firestore, onde os documentos dos usuários são armazenados
  final userCollection = FirebaseFirestore.instance.collection("Users");


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Seu Perfil 2",
            style: TextStyle(color: Colors.grey[300]),
          ),
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey[300], //cor da seta do navegation.push
          
        ),
        
        body: 
        
        StreamBuilder<DocumentSnapshot>(
            // O `stream` aqui escuta as mudanças em tempo real no documento específico do Firestore
            // A coleção "Users" contém os documentos dos usuários e `currentUser.email` é o ID do documento
            // (presumidamente, o email do usuário atual logado). O método `snapshots()` retorna um fluxo de
            // atualizações (stream) sempre que o documento é alterado.
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.email)
                .snapshots(),
            builder: (context, snapshot) {
// get user data
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                username = userData["username"];
                return ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // foto de perfil
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: userCollection
                                .doc(widget.email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              // Obtém os dados do documento
                              var userData =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              // Verifica se há comentários (ou outros dados que você deseja exibir)
                              if (userData['photoUrl'] == null) {
                                return Center(
                                    child: Icon(
                                  Icons.person,
                                  size: 72,
                                ));
                              }

                              // Exibe a lista de comentários

                              return ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(),
                                  constraints: BoxConstraints(minHeight: 60),
                                  child: Image.network(
                                    userData['photoUrl'],
                                    fit: BoxFit
                                        .cover, // Preenche todo o espaço do container
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                          child: Icon(Icons
                                              .error)); // Ícone de erro se a imagem não carregar
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // user email
                    Text(
                      widget.email,
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
                    ),

                    // username
                    MyTextBox(
                      text: userData['username'],
                      sectionName: 'username',
                      onPressed: () {}, edit: false,
                    ),
                    // bio
                    MyTextBox(
                      text: userData['bio'],
                      sectionName: 'bio',
                      onPressed: () {}, edit: false,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Meus Posts",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'ERRO ${snapshot.error}!',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
