import 'dart:async';
import 'dart:io';

import 'package:app_base/components/drawer.dart';
import 'package:app_base/components/text_field.dart';
import 'package:app_base/components/wall_post.dart';
import 'package:app_base/components/wall_recipe_post.dart';
import 'package:app_base/helper/helper_methods.dart';
import 'package:app_base/pages/home_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedDietPage extends StatefulWidget {
  const FeedDietPage({super.key});

  @override
  State<FeedDietPage> createState() => _FeedDietPageState();
}

class _FeedDietPageState extends State<FeedDietPage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller

  double _teste = 0;

  void _refresh() {
    _teste = _teste;
  }

  void initState() {
    _refresh();
    super.initState();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void goToHomePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Receitas",
          style:
              TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
        ),

        actions: [],

        foregroundColor: Colors.grey[300], //cor do drawer / gaveta
      ),
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onHomeTap: goToHomePage,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                // Define o fluxo de dados que o StreamBuilder irá escutar
                stream: FirebaseFirestore.instance
                    .collection(
                        "Recipe") // Acessa a coleção chamada "User Posts"
                    .orderBy("TimeStamp",
                        descending:
                            false) // Ordena pelo campo "TimeStamp" em ordem crescente
                    .snapshots(), // Retorna um fluxo de atualizações em tempo real
                builder: (context, snapshot) {
                  // Verifica se o snapshot contém dados
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Erro: ${snapshot.error.toString()}"));
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot
                          .data!.docs.length, // Conta o número de documentos
                      itemBuilder: (context, index) {
                        // Obtém o documento do índice atual
                        final post = snapshot.data!.docs[index];
                        print(post); // Log do documento

                        return WallRecipePost(
                          tituloReceita: post["TitleRecipe"],
                          imgURL: post['FileURL'],
                          tipoReceita: post['TypeRecipeDiet'],
                          saborReceita: post['TypeDietFlavor'],
                          ingredientes:  List<String>.from(post['Ingredients'] ??
                                []),
                          comoFazer: List<String>.from(post['HowMake'] ??
                                []),
                          quemPostou: post['UserEmailPost'],
                          likes: List<String>.from(post['Likes'] ??
                                []), // Converte Likes para uma lista de Strings
                          postId: post.id,
                        );
                      },
                    );
                  }

                  // Retorna um indicador de progresso se nada mais se aplicar
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
             Text(
              "Logado como ${currentUser.email}",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
