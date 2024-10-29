import 'package:app_base/components/comment_button.dart';
import 'package:app_base/components/delete_button.dart';
import 'package:app_base/components/like_button.dart';
import 'package:app_base/pages/comments_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:app_base/pages/profile_page2.dart';
import 'package:app_base/pages/step_by_step_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WallRecipePost extends StatefulWidget {
  final String postId;
  final String tituloReceita;
  final String imgURL;
  final String tipoReceita;
  final String saborReceita;
  final List<String> ingredientes;
  final List<String> comoFazer;
  final String quemPostou;
  final List<String> likes;
  const WallRecipePost(
      {super.key,
      required this.tituloReceita,
      required this.imgURL,
      required this.tipoReceita,
      required this.saborReceita,
      required this.ingredientes,
      required this.comoFazer,
      required this.quemPostou,
      required this.likes, required this.postId});

  @override
  State<WallRecipePost> createState() => _WallRecipePostState();
}

class _WallRecipePostState extends State<WallRecipePost> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  final userCollection = FirebaseFirestore.instance.collection("Users");
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    // resolve o erro em likes: List<String>.from(post['Likes'] ?? []),
  }

void goToProfilePage2(String email) {

  if(currentUser.email != email){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage2(email: email)),
  ); 
  }
  if(currentUser.email == email){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage()),
  ); 
  }
 
}


  void toggledLike() {
    setState(() {
      isLiked =
          !isLiked; // Atualiza o estado da variável `isLiked`, alternando seu valor entre `true` e `false`.
    });

    // Acessa o documento específico no Firestore usando o ID fornecido por `widget.postId`.
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("Recipe").doc(widget.postId);

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

  void Comment() {}

// adicionar comentario

  void deletePost() {
    // Exibe o diálogo de confirmação antes de deletar o post
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deletar post"),
        content: const Text("Você tem certeza que quer deletar sua postagem?"),
        actions: [
          // Botão de cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          // Botão de deletar
          TextButton(
            onPressed: () async {
              try {
                // Primeiro, obtém os dados do post para verificar se há uma imagem associada
                final postDoc = await FirebaseFirestore.instance
                    .collection("Recipe")
                    .doc(widget.postId)
                    .get();

                // Se o post contém uma URL de imagem, exclua a imagem no Firebase Storage
                if (postDoc.exists && postDoc.data() != null) {
                  final postData = postDoc.data() as Map<String, dynamic>;
                  if (postData.containsKey('FileURL') &&
                      postData['FileURL'] != null) {
                    final fileUrl = postData['FileURL'] as String;

                    // Referência para a imagem no Firebase Storage
                    final ref = FirebaseStorage.instance.refFromURL(fileUrl);

                    // Exclui a imagem do Storage
                    await ref.delete();
                    print("Imagem excluída do Firebase Storage.");
                  }
                }

                // Exclui os comentários do post no Firestore
                final commentDocs = await FirebaseFirestore.instance
                    .collection("Recipe")
                    .doc(widget.postId)
                    .collection("Comments")
                    .get();

                for (var doc in commentDocs.docs) {
                  await FirebaseFirestore.instance
                      .collection("User Post")
                      .doc(widget.postId)
                      .collection("Comments")
                      .doc(doc.id)
                      .delete();
                }

                // Após excluir os comentários, exclua o post no Firestore
                await FirebaseFirestore.instance
                    .collection("Recipe")
                    .doc(widget.postId)
                    .delete();

                print("Post e comentários deletados com sucesso.");
                Navigator.pop(context); // Fecha o diálogo após a exclusão
              } catch (error) {
                print("Erro ao deletar post ou imagem: $error");
              }
            },
            child: Text("Deletar"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (context) => StepByStepPage(postId: widget.postId,
        tituloReceita: widget.tituloReceita, imgURL:  widget.imgURL, tipoReceita: widget.tipoReceita, saborReceita: widget.saborReceita,
         ingredientes: widget.ingredientes, comoFazer: widget.comoFazer, quemPostou: widget.quemPostou)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
             color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(widget.imgURL),
            fit: BoxFit.cover,
          ),),
      
        padding: EdgeInsets.all(50),
        child: Stack(
          children: [
      Align(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  widget.tituloReceita,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[300]
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              alignment: Alignment.center,
            ),
           
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          
                         
                 
                      LikeButton(isLiked: isLiked, onTap: toggledLike),
                      const SizedBox(
                        width: 5,
                      ),
              // like count
                      Text(
                        widget.likes.length.toString(),
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                        
                      
                    ),
                    GestureDetector(
                      onTap: () {
                            // deletePost();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(
                              postId: widget.postId,
                              user: widget.quemPostou,
                              type: 'Recipe',
                            
                              message: widget.tituloReceita,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                             CommentButton(onTap: () {
                              // deletePost();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(
                                postId: widget.postId,
                                user: widget.quemPostou,
                                type: 'Recipe',
                              
                                message: widget.tituloReceita,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          width: 5,
                        ),
                             StreamBuilder(
                          // Define o fluxo de dados que o StreamBuilder irá escutar
                          stream: FirebaseFirestore.instance
                              .collection(
                                  "Recipe") // Acessa a coleção chamada "User Post"
                              .doc(widget.postId)
                              .collection("Comments")
                              .snapshots(), // Retorna um fluxo de atualizações em tempo real
                          builder: (context, snapshot) {
                            // Verifica se o snapshot contém dados
                            if (snapshot.hasData) {
                              // Conta o número de comentários (documentos na coleção "Comments")
                              int commentCount = snapshot.data!.docs.length;
                                    
                              return Text(
                                "$commentCount",
                                style: TextStyle(color: Colors.grey[700]),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Erro: ${snapshot.error.toString()}"),
                              );
                            }
                            return const Center(
                              child:
                                  CircularProgressIndicator(), // Exibe um loading enquanto os dados estão sendo carregados
                            );
                          },
                        ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                alignment: Alignment.bottomLeft,
              ),
            ),
            // botoes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // like
                
                const SizedBox(
                  width: 10,
                ),
      // comentario
      //               Column(
      //                 children: [
      // // comment button
      //                   CommentButton(onTap: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => CommentsPage(
      //                           postId: widget.postId,
      //                           user: widget.user,
      //                           time: widget.time,
      //                           message: widget.message,
      //                         ),
      //                       ),
      //                     );
      //                   }),
      //                   const SizedBox(
      //                     height: 5,
      //                   ),
      // // comment count
      //                   StreamBuilder(
      //                     // Define o fluxo de dados que o StreamBuilder irá escutar
      //                     stream: FirebaseFirestore.instance
      //                         .collection(
      //                             "User Post") // Acessa a coleção chamada "User Post"
      //                         .doc(widget.postId)
      //                         .collection("Comments")
      //                         .snapshots(), // Retorna um fluxo de atualizações em tempo real
      //                     builder: (context, snapshot) {
      //                       // Verifica se o snapshot contém dados
      //                       if (snapshot.hasData) {
      //                         // Conta o número de comentários (documentos na coleção "Comments")
      //                         int commentCount = snapshot.data!.docs.length;
      
      //                         return Text(
      //                           "$commentCount",
      //                           style: TextStyle(color: Colors.grey[700]),
      //                         );
      //                       } else if (snapshot.hasError) {
      //                         return Center(
      //                           child: Text("Erro: ${snapshot.error.toString()}"),
      //                         );
      //                       }
      //                       return const Center(
      //                         child:
      //                             CircularProgressIndicator(), // Exibe um loading enquanto os dados estão sendo carregados
      //                       );
      //                     },
      //                   ),
      //                 ],
      //               ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
      
            // comments
          ],
        ),
      ),
    );
  }
}
