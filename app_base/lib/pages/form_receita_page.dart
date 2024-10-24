import 'package:app_base/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:win32/win32.dart';

class ReceitaFormScreen extends StatefulWidget {
  @override
  _ReceitaFormScreenState createState() => _ReceitaFormScreenState();
}

class _ReceitaFormScreenState extends State<ReceitaFormScreen> {
  // Controladores de estado
  String? tipoReceita; // Veggie, Intolerante a lactose, Celíaco
  String? saborReceita; // Café da manhã, Comida, Sobremesa
  File? _imagemSelecionada; // Imagem do alimento
  String? _selectedFileName;
  final  tituloController = TextEditingController();
  final  _ingredientesController = TextEditingController();
  final  _comoFazerController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final ImagePicker _picker = ImagePicker();

  // Função para selecionar imagem
  Future<void> _selecionarImagem() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
         _selectedFileName = pickedFile.name;
      });
    }
  }

  // Função para enviar o formulário
  void _enviarFormulario() {
    if (tituloController.text.isNotEmpty &&
        tipoReceita != null &&
        saborReceita != null &&
        _ingredientesController.text.isNotEmpty &&
        _comoFazerController.text.isNotEmpty &&
        _imagemSelecionada != null) {
      // Exemplo de ação de envio (pode ser substituído por envio a um servidor, etc.)
      print("Formulário enviado!");
      print("Título: ${tituloController.text}");
      print("Tipo: $tipoReceita");
      print("Sabor: $saborReceita");
      print("Ingredientes: ${_ingredientesController.text}");
      print("Como Fazer: ${_comoFazerController.text}");
      print("Imagem: ${_imagemSelecionada!.path}");

       
      // Se houver um arquivo selecionado, faça o upload para o Firebase Storage
      String fileName = _selectedFileName!;

      // Adiciona um timestamp para garantir nomes de arquivos únicos
      Reference ref = FirebaseStorage.instance.ref().child(
          'uploads/${fileName}_${Timestamp.now().millisecondsSinceEpoch}');

      ref.putFile(_imagemSelecionada!).then((snapshot) {
        // Após o upload, obtenha a URL de download
        snapshot.ref.getDownloadURL().then((fileUrl) {
          // Salva o post com a URL do arquivo no Firestore
          _salvarNoFirestore(fileUrl);
        });
      }).catchError((error) {
        print('Erro ao fazer upload do arquivo: $error');
      });
  
      // Se não houver arquivo, salva apenas a mensagem de texto
   
      
    } else {
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Preecha todos os campos."),
          content: Text("Reveja todos os campos e tente enviar novamente."),
          actions: [
           TextButton(onPressed: (){
             Navigator.of(context).pop();
           }, child: Text("Fechar", style: TextStyle(color: Colors.red),))
          ],
        );
      });
    }
  }

  
// Função para salvar os dados no Firestore
  Future<void> _salvarNoFirestore(String? fileUrl) async {
    Map<String, dynamic> postData = {
      "UserEmailPost": currentUser.email,
      "TitleRecipe":  tituloController.text,
      "TypeRecipeDiet": tipoReceita,
      "TypeDietFlavor": saborReceita,
      "Ingredients": _ingredientesController.text,
      "HowMake": _comoFazerController.text,
      "TimeStamp": Timestamp.now(),
      'Likes': [],
      "FileURL": fileUrl
    };

    // Se houver uma URL de arquivo, adicione-a ao Firestore
  


    

    // Salva os dados no Firestore
    FirebaseFirestore.instance.collection("Recipe").add(postData).then((_) {
      // Limpa os campos e atualiza o estado após salvar
      _comoFazerController.clear();
      _ingredientesController.clear();
      tituloController.clear();
      setState(() {
        tipoReceita = null;
        saborReceita = null;
        _imagemSelecionada = null;
        _selectedFileName = null;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    
      print('Post salvo com sucesso no Firestore.');
    }).catchError((error) {
      print('Erro ao salvar o post no Firestore: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Formulário de Receita",
          style:
              TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
        ),

        actions: [],

        foregroundColor: Colors.grey[300], //cor do drawer / gaveta
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Imagem do Alimento', style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: _selecionarImagem,
                    child: _imagemSelecionada != null
                        ? Image.file(
                            _imagemSelecionada!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey[400],
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 16,
            ),
            // Título
            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: 'Título da Receita',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Tipo de Receita (Veggie, Intolerante a lactose, Celíaco)
            Text('Tipo da Receita'),
            Column(
              children: <Widget>[
                RadioListTile<String>(
                  title: const Text('Veggie'),
                  value: 'Veggie',
                  groupValue: tipoReceita,
                  onChanged: (value) {
                    setState(() {
                      tipoReceita = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Intolerante a Lactose'),
                  value: 'Intolerante a Lactose',
                  groupValue: tipoReceita,
                  onChanged: (value) {
                    setState(() {
                      tipoReceita = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Celíaco'),
                  value: 'Celíaco',
                  groupValue: tipoReceita,
                  onChanged: (value) {
                    setState(() {
                      tipoReceita = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Sabor (Café da manhã, Comida, Sobremesa)
            Text('Sabor'),
            Column(
              children: <Widget>[
                RadioListTile<String>(
                  title: const Text('Café da manhã'),
                  value: 'Café da manhã',
                  groupValue: saborReceita,
                  onChanged: (value) {
                    setState(() {
                      saborReceita = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Comida'),
                  value: 'Comida',
                  groupValue: saborReceita,
                  onChanged: (value) {
                    setState(() {
                      saborReceita = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Sobremesa'),
                  value: 'Sobremesa',
                  groupValue: saborReceita,
                  onChanged: (value) {
                    setState(() {
                      saborReceita = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Ingredientes
            TextField(
              controller: _ingredientesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Ingredientes',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Como fazer
            TextField(
              controller: _comoFazerController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Como Fazer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Imagem do alimento

            SizedBox(height: 16),
            Center(
                child:
                    MyButton(onTap: _enviarFormulario, text: 'Enviar Receita'))
          ],
        ),
      ),
    );
  }
}
