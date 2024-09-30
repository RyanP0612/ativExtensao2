import 'dart:io';

import 'package:app_base/components/drawer.dart';
import 'package:app_base/components/text_field.dart';
import 'package:app_base/components/wall_post.dart';
import 'package:app_base/helper/helper_methods.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _selectedFile; // Armazena o arquivo selecionado
  String? _selectedFileName; // Armazena o nome do arquivo

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void selecionarArquivo() {
    FilePicker.platform.pickFiles().then((result) {
      if (result != null) {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = result.files.single.name;

        // Exibe uma mensagem confirmando o arquivo selecionado
        print('Arquivo selecionado: $_selectedFileName');
      } else {
        // Se nenhum arquivo foi selecionado
        print('Nenhum arquivo selecionado');
      }
    }).catchError((error) {
      print('Erro ao selecionar o arquivo: $error');
    });
  }

  // post message

  void postMessage() {
    if (textController.text.isNotEmpty) {
      if (_selectedFile != null) {
        // Se houver um arquivo selecionado, faça o upload para o Firebase Storage
        String fileName = _selectedFileName!;

        Reference ref =
            FirebaseStorage.instance.ref().child('uploads/$fileName');
        ref.putFile(_selectedFile!).then((snapshot) {
          // Após o upload, obtenha a URL de download
          snapshot.ref.getDownloadURL().then((fileUrl) {
            _salvarNoFirestore(fileUrl); // Salva o post com a URL do arquivo
          });
        });
      } else {
        // Se não houver arquivo, salva apenas a mensagem de texto
        _salvarNoFirestore(null);
      }
    } else {
      print('Campo de texto vazio. Não é possível postar.');
    }
  }

  void _salvarNoFirestore(String? fileUrl) {
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

<<<<<<< HEAD
    // Salva os dados no Firestore
    FirebaseFirestore.instance.collection("User Post").add(postData).then((_) {
      print('Mensagem postada com sucesso!');
    }).catchError((error) {
      print('Erro ao postar a mensagem: $error');
=======
    // limpar textFieldRTHTEHH

    setState(() {
      textController.clear();
>>>>>>> 490aa8716c4888bbafffef5397703fbf9deb57cd
    });
  }

  void selecionarImagemOuVideo() {
    final ImagePicker _picker = ImagePicker();

    _picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        // Exibe o caminho do arquivo selecionado
        print('Arquivo selecionado: ${pickedFile.path}');
      } else {
        // Se nenhum arquivo foi selecionado
        print('Nenhum arquivo selecionado');
      }
    }).catchError((error) {
      print('Erro ao selecionar o arquivo: $error');
    });

    _selectedFile = null;
    _selectedFileName = '';
    textController.clear();
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
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

                        print(post);

                        return LeticiaLindaPost(
                          message: post['Message'],
                          user: post["UserEmail"],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post["TimeStamp"]),
                          teste: post,
                        );

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
                      onPressed: selecionarArquivo,
                      icon: _selectedFile != null
                          ? Icon(Icons.image_aspect_ratio)
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
