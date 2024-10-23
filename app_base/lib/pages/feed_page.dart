import 'dart:async';
import 'dart:io';

import 'package:app_base/components/drawer.dart';
import 'package:app_base/components/text_field.dart';
import 'package:app_base/components/wall_post.dart';
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

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();
  
  bool ArquivoEscolhido = false;
  StreamController<bool> arquivoEscolhidoController = StreamController<bool>();

  File? _selectedFile; // Armazena o arquivo selecionado
  String? _selectedFileName; // Armazena o nome do arquivo
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

// Função para mostrar o Bottom Sheet
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Altura do Bottom Sheet
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Câmera'),
                onTap: () {
                  _selectImageOrVideo(ImageSource.camera);
                  Navigator.of(context).pop(); // Fecha o Bottom Sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Galeria'),
                onTap: () {
                  _selectImageOrVideo(ImageSource.gallery);
                  Navigator.of(context).pop(); // Fecha o Bottom Sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o Bottom Sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Função para selecionar imagem ou vídeo
  Future<void> _selectImageOrVideo(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    // Seleciona o arquivo com base na fonte escolhida
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedFile = File(pickedFile.path);
      _selectedFileName = pickedFile.name;

      // Exibe uma mensagem confirmando o arquivo selecionado
      print('Arquivo selecionado: $_selectedFileName');
      setState(() {
        ArquivoEscolhido = true; // Atualiza o estado do arquivo escolhido
        // arquivoEscolhidoController.stream = true;
      });
      arquivoEscolhidoController.add(true);
      // Aqui você pode chamar setState se necessário
    } else {
      // Se nenhum arquivo foi selecionado
      print('Nenhum arquivo selecionado');
    }
  }

// Função para postar a mensagem
  void postMessage() {
    if (textController.text.isNotEmpty) {
      if (_selectedFile != null) {
        // Se houver um arquivo selecionado, faça o upload para o Firebase Storage
        String fileName = _selectedFileName!;

        // Adiciona um timestamp para garantir nomes de arquivos únicos
        Reference ref = FirebaseStorage.instance.ref().child(
            'uploads/${fileName}_${Timestamp.now().millisecondsSinceEpoch}');

        ref.putFile(_selectedFile!).then((snapshot) {
          // Após o upload, obtenha a URL de download
          snapshot.ref.getDownloadURL().then((fileUrl) {
            // Salva o post com a URL do arquivo no Firestore
            _salvarNoFirestore(fileUrl);
          });
        }).catchError((error) {
          print('Erro ao fazer upload do arquivo: $error');
        });
      } else {
        // Se não houver arquivo, salva apenas a mensagem de texto
        _salvarNoFirestore(null);
      }
    } else {
      print('Campo de texto vazio. Não é possível postar.');
    }
  }

// Função para salvar os dados no Firestore
  Future<void> _salvarNoFirestore(String? fileUrl) async {
    Map<String, dynamic> postData = {
      "UserEmail": currentUser.email,
      "Message": textController.text,
      "TimeStamp": Timestamp.now(),
      'Likes': [],
    };

    // Se houver uma URL de arquivo, adicione-a ao Firestore
    if (fileUrl != null) {
      postData['FileURL'] = fileUrl;
    }

    final userData = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .get();

    print("current user dnv ${currentUser.displayName}");
    if (userData.data()!.containsKey("photoUrl")) {
      postData["ProfilePhoto"] = userData["photoUrl"];
    }
    postData["Username"] = userData["username"];

    // Salva os dados no Firestore
    FirebaseFirestore.instance.collection("User Post").add(postData).then((_) {
      // Limpa os campos e atualiza o estado após salvar
      _selectedFile = null;
      _selectedFileName = '';
      textController.clear();
      arquivoEscolhidoController.add(false);
      setState(() {
        ArquivoEscolhido = false; // Reseta o estado do arquivo escolhido
      });
      print('Post salvo com sucesso no Firestore.');
    }).catchError((error) {
      print('Erro ao salvar o post no Firestore: $error');
    });
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
          "Leticia lindaaa 123",
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
            // leticia linda 123

            Expanded(
              child: StreamBuilder(
                // Define o fluxo de dados que o StreamBuilder irá escutar
                stream: FirebaseFirestore.instance
                    .collection(
                        "User Post") // Acessa a coleção chamada "User Posts"
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

                        return LeticiaLindaPost(
                            message: post['Message'],
                            user: post["UserEmail"],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ??
                                []), // Converte Likes para uma lista de Strings
                            time: formatDate(
                                post["TimeStamp"]), // Formata o timestamp
                            fileURL: post.data().containsKey('FileURL')
                                ? post['FileURL']
                                : null,
                            fileURLProfile:
                                post.data().containsKey('ProfilePhoto')
                                    ? post['ProfilePhoto']
                                    : null,
                            username: post.data().containsKey('Username')
                                ? post['Username']
                                : null);
                      },
                    );
                  }

                  // Retorna um indicador de progresso se nada mais se aplicar
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            // StreamBuilder<bool>(
            //   stream: arquivoEscolhidoController.stream,
            //   builder: (context, snapshot) {
            //     // Verifica se o snapshot tem dados e se o valor é 'true'
            //     if (snapshot.hasData && snapshot.data == true) {
            //       // Exibe o popup com a imagem
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: Text('Imagem Escolhida'),
            //               content: Image.file(
            //                 _selectedFile!,
            //                 height: 150,
            //                 width: 150,
            //               ),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.of(context).pop();
            //                   },
            //                   child: Text('Fechar'),
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       });
            //     }
            //     return Center(
            //       child: Text('Aguardando seleção...'),
            //     );
            //   },
            // ),
            // post mensagem
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // textfield

                  Expanded(
                      child: MyTextField(
                          controller: textController,
                          hintText: ArquivoEscolhido
                              ? "Escreva algo com seu arquivo..."
                              : "Escreva algo...",
                          obscureText: false)),

                  //  postbutton
                  IconButton(
                      onPressed: () => _showPicker(context),
                      icon: ArquivoEscolhido
                          ? Icon(Icons.photo_library)
                          : Icon(Icons.image)),
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
