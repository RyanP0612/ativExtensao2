import 'package:app_base/components/comment.dart';
import 'package:app_base/components/comment_button.dart';
import 'package:app_base/components/delete_button.dart';
import 'package:app_base/components/like_button.dart';
import 'package:app_base/helper/helper_methods.dart';
import 'package:app_base/pages/comments_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:app_base/pages/profile_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeticiaLindaPost extends StatefulWidget {
  final String message;
  final String user;
  final String? fileURLProfile;
  final String time;
  final String postId;
  final String? username;
  final List<String> likes;
  final String? fileURL;

  const LeticiaLindaPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time,
      this.fileURL,
      this.fileURLProfile,
      this.username});

  @override
  State<LeticiaLindaPost> createState() => _LeticiaLindaPostState();
}

class _LeticiaLindaPostState extends State<LeticiaLindaPost> {
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
                    .collection("User Post")
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
                    .collection("User Post")
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
                    .collection("User Post")
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
    return Container(
     
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // mensagem e email do usuario
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // grupo de texto (message + user email)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       ClipOval(
                         child: Container(
                          color: Colors.grey[300],
                            width:40,
                            height:40,
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: userCollection
                                  .doc(widget.user)
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
                                    size: 35,
                                  ));
                                }
                         
                                // Exibe a lista de comentários
                         
                                return GestureDetector(
                                  onTap: ()=> goToProfilePage2(widget.user),
                                  child: ClipOval(
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
                                  ),
                                );
                              },
                            ),
                          ),
                       ),
                      SizedBox(
                        width: 5,
                      ),
                     SizedBox(
                    
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: userCollection
                                  .doc(widget.user)
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
                                if (userData['username'] == null) {
                                  return Center(
                                      child: Icon(
                                    Icons.error,
                                    size: 35,
                                  ));
                                }
                         
                                // Exibe a lista de comentários
                         
                                return Center(
                                  child: Text(userData["username"]),
                                );
                              },
                            ),
                          ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 Center(
  child: Container(
    width: MediaQuery.of(context).size.width /1.5,  // Defina uma largura máxima para o Container
    child: Text(
      widget.message,
      softWrap: true,  // Quebra o texto em várias linhas automaticamente
    ),
  ),
),
SizedBox(height: 5,),


                  widget.fileURL != null
                      ? Row(
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width / 1.5,
                              child: Image.network(
                                widget.fileURL!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        " * ",
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
              // so o dono do post consegue deletar o post

              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
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
                  CommentButton(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsPage(
                          postId: widget.postId,
                          user: widget.user,
                          time: widget.time,
                          message: widget.message,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 5,
                  ),
// comment count
                  StreamBuilder(
                    // Define o fluxo de dados que o StreamBuilder irá escutar
                    stream: FirebaseFirestore.instance
                        .collection(
                            "User Post") // Acessa a coleção chamada "User Post"
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
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          // comments
        ],
      ),
    );
  }
}
