import 'package:app_base/components/comment_button.dart';
import 'package:app_base/components/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeticiaLindaPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const LeticiaLindaPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes});

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
                      Navigator.pop(context); 
                      },
                    child: Text("Cancelar")),
                     // save button
                TextButton(
                    onPressed: () {addComment(_commentTextController.text);                    _commentTextController.clear();
                    },
                    child: Text("Postar")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
          
              
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
          const SizedBox(width: 10,),
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

          // comments
          StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("User Post").doc(widget.postId).collection("Comments").orderBy("CommentTime", descending: true).snapshots(), builder:(context, snapshot) {
            
          },)
        ],
      ),
    );
  }
}
