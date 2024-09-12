import 'package:app_base/components/text_field.dart';
import 'package:app_base/components/wall_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message

  void postMessage() {
// só poste se tiver algo no textfield
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Post").add({
        "UserEmail": currentUser.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        'Likes':[],
      });
    }

    // limpar textField

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Leticia lindaaa 123",
          style:
              TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: signOut,
              icon: Icon(
                Icons.logout,
                color: Colors.grey[300],
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // leticia linda 123

            Expanded(
              child: StreamBuilder(
                // Define o fluxo de dados que o StreamBuilder irá escutar
                stream: FirebaseFirestore.instance
                    .collection(
                        "User Post") // Acessa a coleção chamada "User Posts" no Firestore
                    .orderBy("TimeStamp",
                        descending:
                            false) // Ordena os documentos pelo campo "Timestamp" em ordem crescente
                    .snapshots(), // Retorna um fluxo de atualizações em tempo real
                builder: (context, snapshot) {
                  // Verifica se o snapshot contém dados
                  if (snapshot.hasData) {
                    return ListView.builder(
                      // tira o erro que da toda hora kkk
                      itemCount: snapshot.data!.docs.length,
                      // Cria uma lista de itens de forma eficiente
                      itemBuilder: (context, index) {
                        // Obtém o documento do índice atual da lista de documentos
                        final post = snapshot.data!.docs[index];
                        return LeticiaLindaPost(
                            message: post['Message'], user: post["UserEmail"], postId: post.id,likes: List<String>.from(post['Likes'] ?? []),);
                        // O retorno do widget para cada item da lista deve ser definido aqui
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro: ${snapshot.error.toString()}"),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // post mensagem
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // textfield
                  Expanded(
                      child: MyTextField(
                          controller: textController,
                          hintText: "Escreva algo...",
                          obscureText: false)),

                  //  postbutton
                  IconButton(
                      onPressed: postMessage,
                      icon: Icon(Icons.arrow_circle_up)),
                ],
              ),
            ),

            // logado como
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
