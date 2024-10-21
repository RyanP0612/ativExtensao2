import 'dart:io';

import 'package:app_base/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// Pega o usuário atual autenticado usando o Firebase Authentication
  final currentUser = FirebaseAuth.instance.currentUser!;

  TextEditingController _textEditingController = TextEditingController();

// Referência para a coleção "Users" no Firestore, onde os documentos dos usuários são armazenados
  final userCollection = FirebaseFirestore.instance.collection("Users");

  bool ArquivoEscolhido = false;
  String username = "";
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
        postMessage();
      });

      // Aqui você pode chamar setState se necessário
    } else {
      // Se nenhum arquivo foi selecionado
      print('Nenhum arquivo selecionado');
    }
  }

  void postMessage() {
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
          editProfilePhoto(fileUrl);
        });
      }).catchError((error) {
        print('Erro ao fazer upload do arquivo: $error');
      });
    } else {
      // Se não houver arquivo, salva apenas a mensagem de texto
      print("nao selecionado");
    }
  }

  Future<void> editProfilePhoto(String fileUrl) async {
    print("Tentando salvar a URL no Firestore...");
    int attempts = 0;
    while (attempts < 3) {
      try {
        await userCollection.doc(currentUser.email).set(
          {"photoUrl": fileUrl},
          SetOptions(merge: true),
        );
        await currentUser.updatePhotoURL(fileUrl);
        currentUser.reload();

        print("URL do arquivo salva com sucesso!");
        break; // Sai do loop em caso de sucesso
      } catch (e) {
        print("Erro ao salvar a URL no Firestore: $e");
        attempts++;
        await Future.delayed(
            Duration(seconds: 1)); // Espera 1 segundo antes de tentar novamente
      }
    }
  }

// Função assíncrona que edita um campo específico de um documento no Firestore
  Future<void> editField(String field) async {
    // Variável para armazenar o novo valor que o usuário irá inserir
    String newValue = "";

    // Exibe um diálogo para o usuário inserir um novo valor para o campo
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Configurações visuais do AlertDialog
        backgroundColor: Colors.grey[900], // Cor de fundo escura para o diálogo
        title: Text(
          "Editar " +
              field, // Título do diálogo, informando qual campo será editado
          style: TextStyle(color: Colors.white), // Texto branco para o título
        ),

        // TextField para o usuário inserir o novo valor
        content: TextField(
          controller: _textEditingController,
          autofocus:
              true, // Faz o campo ser focado automaticamente ao abrir o diálogo
          style: TextStyle(
              color: Colors.white), // Cor branca para o texto inserido
          decoration: InputDecoration(
            hintText:
                "Entre com novo $field", // Placeholder para o campo de texto
            hintStyle:
                TextStyle(color: Colors.white), // Cor branca para o placeholder
          ),
          onChanged: (value) {
            // Atualiza a variável `newValue` com o valor inserido pelo usuário
            newValue = value;
          },
        ),

        // Botões de ação no diálogo
        actions: [
          // Botão de cancelar
          TextButton(
            onPressed: () =>
                Navigator.pop(context), // Fecha o diálogo sem fazer nada
            child: Text(
              "Cancelar",
              style: TextStyle(
                  color: Colors.white), // Cor branca para o texto do botão
            ),
          ),

          // Botão de salvar
          TextButton(
            // Fecha o diálogo e retorna o valor inserido pelo usuário
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              "Salvar",
              style: TextStyle(
                  color: Colors.white), // Cor branca para o texto do botão
            ),
          ),
        ],
      ),
    );

    // Se o valor inserido não for vazio ou não contiver apenas espaços
    if (newValue.trim().length > 0) {
      // Faz um update no documento do usuário no Firestore
      // O campo especificado (passado como argumento) é atualizado com o novo valor
      await userCollection.doc(currentUser.email).update(
        {field: newValue},
      );
      if (field == 'username') {
        await currentUser.reload();

        await currentUser.updateDisplayName(_textEditingController.text.trim());
        await currentUser.reload();

        print("eu aqui\n\n ${_textEditingController.text}");
        print("current user display name: ${currentUser.displayName}");
      }
    }

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Seu Perfil",
            style: TextStyle(color: Colors.grey[300]),
          ),
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey[300], //cor da seta do navegation.push
        ),
        body: StreamBuilder<DocumentSnapshot>(
            // O `stream` aqui escuta as mudanças em tempo real no documento específico do Firestore
            // A coleção "Users" contém os documentos dos usuários e `currentUser.email` é o ID do documento
            // (presumidamente, o email do usuário atual logado). O método `snapshots()` retorna um fluxo de
            // atualizações (stream) sempre que o documento é alterado.
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.email)
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
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.settings,
                            color: Colors.transparent,
                          ),
                          style: ButtonStyle(
                            overlayColor: MaterialStatePropertyAll(
                                Colors.transparent), // Remove efeito de clique
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: userCollection
                                .doc(currentUser.email)
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
                        IconButton(
                            onPressed: () => _showPicker(context),
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey[400],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // user email
                    Text(
                      currentUser.email!,
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
                      onPressed: () => editField('username'),
                      edit: true,
                    ),
                    // bio
                    MyTextBox(
                      text: userData['bio'],
                      sectionName: 'bio',
                      onPressed: () => editField('bio'),
                      edit: true,
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
