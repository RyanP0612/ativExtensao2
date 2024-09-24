import 'package:app_base/components/comment.dart';
import 'package:app_base/components/comment_button.dart';
import 'package:app_base/components/like_button.dart';
import 'package:app_base/helper/helper_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeticiaLindaPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const LeticiaLindaPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes, required this.time});

  @override
  State<LeticiaLindaPost> createState() => _LeticiaLindaPostState();
}

class _LeticiaLindaPostState extends State<LeticiaLindaPost> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    // resolve o erro em likes: List<String>.from(post['Likes'] ?? []),
  }

  void toggledLike() {
    setState(() {
      isLiked =
          !isLiked; // Atualiza o estado da variável `isLiked`, alternando seu valor entre `true` e `false`.
    });

    // Acessa o documento específico no Firestore usando o ID fornecido por `widget.postId`.
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Post").doc(widget.postId);

    if (isLiked) {
      // Se a postagem foi marcada como curtida (isLiked é `true`):
      // Adiciona o e-mail do usuário atual ao campo "Likes" do documento no Firestore.
      // `FieldValue.arrayUnion` garante que o e-mail seja adicionado apenas se ainda não estiver presente.
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // Se a postagem foi desmarcada como curtida (isLiked é `false`):
      // Remove o e-mail do usuário atual do campo "Likes" do documento no Firestore.
      // `FieldValue.arrayRemove` garante que o e-mail seja removido apenas se estiver presente.
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

// adicionar comentario
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Post")
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now() //lembrar de formatar no dispray
    });
  }

// show a dialog box
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Adicionar comentario"),
              content: TextField(
                controller: _commentTextController,
                decoration:
                    InputDecoration(hintText: "Escreva um comentário..."),
              ),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      _commentTextController.clear();
                     
                    },
                    child: Text("Cancelar")),
                // save button
                TextButton(
                    onPressed: () {
                       Navigator.pop(context);
                      addComment(_commentTextController.text);
                      _commentTextController.clear();
                    },
                    child: Text("Postar")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // mensagem e email do usuario
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              SizedBox(
                height: 5,
              ),
              Row(
          children: [
            Text(widget.user, style: TextStyle(color: Colors.grey[400]),),
            Text(" * ", style: TextStyle(color: Colors.grey[400]),),
            Text(widget.time, style: TextStyle(color: Colors.grey[400]),),
          ],
        )
            ],
          ),
          SizedBox(
            width: 20,
          ),
          // botoes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // like
              Column(
                children: [
// like button
                  LikeButton(isLiked: isLiked, onTap: toggledLike),
                  const SizedBox(
                    height: 5,
                  ),
// like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
// comentario
              Column(
                children: [
// comment button
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(
                    height: 5,
                  ),
// comment count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20,),

          // comments
          StreamBuilder<QuerySnapshot>(
            // Cria um StreamBuilder que escuta alterações em uma coleção do Firestore.
            stream: FirebaseFirestore.instance
                .collection("User Post")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime",
                    descending:
                        true) // Ordena os comentários pelo campo "CommentTime" em ordem decrescente.
                .snapshots(), // Escuta as alterações na coleção e fornece um stream de dados.
            builder: (context, snapshot) {
              // O builder constrói a interface com base no estado do snapshot.
              // Mostra um círculo de carregamento enquanto os dados estão sendo carregados.
              if (!snapshot.hasData) {
                return Center(
                  child:
                      CircularProgressIndicator(), // Mostra um indicador de progresso centralizado.
                );
              }

              // Retorna uma ListView com os comentários carregados.
              return ListView(
                shrinkWrap:
                    true, // Reduz o tamanho da ListView ao mínimo necessário.
                physics:
                    const NeverScrollableScrollPhysics(), // Desativa a rolagem da ListView.
                children: snapshot.data!.docs.map((doc) {
                  // Mapeia cada documento (comentário) retornado.
                  // Obtém os dados do comentário como um mapa.
                  final commentData = doc.data() as Map<String, dynamic>;

                  // Retorna o widget de comentário com os dados formatados.
                  return Comment(
                      text: commentData["CommentText"], // Texto do comentário.
                      user: commentData[
                          "CommentedBy"], // Usuário que fez o comentário.
                      time: formatDate(commentData[
                          "CommentTime"]) // Formata o tempo do comentário.
                      );
                }).toList(), // Converte o Iterable em uma lista.
              );
            },
          )
        ],
      ),
    );
  }
}
