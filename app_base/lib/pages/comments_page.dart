import 'package:app_base/components/comment.dart';
import 'package:app_base/components/text_field.dart';
import 'package:app_base/helper/helper_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class CommentsPage extends StatefulWidget {
  final String postId;
  final String message;
  final String user;
  final String time;

  CommentsPage({
    super.key,
    required this.postId,
    required this.user,
    required this.time,
    required this.message,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
 final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
    final textController = TextEditingController();


  @override
  
  final _commentTextController = TextEditingController();
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
    return Scaffold(
     backgroundColor:  Colors.grey[300],
      appBar: AppBar(
         backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Comentários",
          style:
              TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height * 0.026,
        ),),

        actions: [],

        foregroundColor: Colors.grey[300], //cor do drawer / gaveta
      ),
      body: 
      

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(15),
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mensagem e informações do usuário
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Texto da mensagem e do usuário
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                   
  Container(
    width: MediaQuery.of(context).size.width /1.5,  // Defina uma largura máxima para o Container
    child: Text(
      widget.message,
      softWrap: true,  // Quebra o texto em várias linhas automaticamente
    
  ),
),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              widget.user,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Text(
                              " • ",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20), // Espaçamento entre a mensagem e os comentários
          
                // StreamBuilder para exibir os comentários
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User Post")
                        .doc(widget.postId)
                        .collection("Comments")
                        .orderBy("CommentTime", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
          
                      // Verifica se há comentários
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "Nenhum comentário ainda",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        );
                      }
          
                      // Exibe a lista de comentários
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final commentData =
                              snapshot.data!.docs[index].data() as Map<String, dynamic>;
          
                          return Comment(
                            text: commentData["CommentText"],
                            user: commentData["CommentedBy"],
                            time: formatDate(commentData["CommentTime"]),
                          );
                        },
                      );
                    },
                  ),
                ),
                  Row(
                    children: [
                      // textfield
                    
                      Expanded(
                          child: MyTextField(
                              controller: textController,
                              hintText: "Escreva algo...",
                              obscureText: false)),
          
                      //  postbutton
                      IconButton(
                       onPressed: () {
            addComment(textController.text);
            textController.clear();
          },
          
                          icon: Icon(Icons.arrow_circle_up)),
                    ],
                  ),
                
          
                // logado como
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      "Logado como ${currentUser.email}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
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
