import 'dart:async';

import 'package:app_base/components/button.dart';
import 'package:app_base/components/delete_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final StreamController<List<String>> _ingredientesStream = StreamController<List<String>>.broadcast();
  final StreamController<List<String>> _HowMakeStream = StreamController<List<String>>.broadcast();
  List<String> ingredientes = []; 
  List<String> HowMake = []; 
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

   
 

  // No construtor ou no initState, você pode adicionar a lista inicial
  _ReceitaFormScreenState() {
    _ingredientesStream.add(ingredientes);
    _HowMakeStream.add(HowMake);
  }

  @override
  void dispose() {
    _ingredientesStream.close(); 
    _HowMakeStream.close();
    super.dispose();
  }

  void _adicionarIngOrHowMake(String ingHowmake) {
    String title = 'Error';
    String content = "Feche e tente novamente";
    if (ingHowmake == "ing") {
      title = "Ingredientes";
      content = "Aqui você pode adicionar ingredientes a sua receita, escreva no campo abaixo o primeiro ingrediente e clique em adicionar posteriormente, caso haja mais, só voltar e adicionar outro!";
    } else if (ingHowmake == "how") {
      title = "Passo a Passo";
      content = "Aqui você pode adicionar o passo a passo da sua receita, escreva no campo abaixo o primeiro passo e clique em adicionar posteriormente, depois de acrescentar, volte aqui e adicione o próximo passo!";
    }

   

    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          constraints: BoxConstraints(maxHeight: 230),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(content),
              TextField(
                controller: ingHowmake == 'ing' ? _ingredientesController : _comoFazerController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: title,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("Fechar", style: TextStyle(color: Colors.red),)),
          TextButton(onPressed: () {
             if(_comoFazerController.text == '' && _ingredientesController.text == '' ){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Preecha todos os campos."),
          content: Text("Reveja todos os campos e tente enviar novamente."),
          actions: [
           TextButton(onPressed: (){
             Navigator.of(context).pop();
           }, child: Text("Fechar", style: TextStyle(color: Colors.red),)),
           
          ],
        );
      });
    }
    else{
 String newEntry = ingHowmake == 'ing' ? _ingredientesController.text : _comoFazerController.text;
            if(ingHowmake == "ing"){
            ingredientes.add(newEntry);    
            }
            else {
            HowMake.add(newEntry);    
            }
          
            _ingredientesStream.add(ingredientes); 
            _HowMakeStream.add(HowMake); 
            _ingredientesController.clear();
            _comoFazerController.clear();
            Navigator.of(context).pop(); // Fecha o dialog
    }
           
          }, child: Text("Adicionar", style: TextStyle(color: Colors.green),)),
        ],
      );
    });
  }

  // Função para enviar o formulário
  void _enviarFormulario() {
    if (tituloController.text.isNotEmpty &&
        tipoReceita != null &&
        saborReceita != null &&
        ingredientes.isNotEmpty &&
        HowMake.isNotEmpty &&
        _imagemSelecionada != null) {
      // Exemplo de ação de envio (pode ser substituído por envio a um servidor, etc.)
      print("Formulário enviado!");
      print("Título: ${tituloController.text}");
      print("Tipo: $tipoReceita");
      print("Sabor: $saborReceita");
      print("Ingredientes: ${_ingredientesController.text}");
      print("Como Fazer: ${_comoFazerController.text}");
      print("aaaaaaaaaaa");
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
           }, child: Text("Fechar", style: TextStyle(color: Colors.red),)),
           
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
      "Ingredients": ingredientes,
      "HowMake": HowMake,
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
      ingredientes.clear();
      HowMake.clear();
   

      setState(() {
        _HowMakeStream.add(HowMake);
        _ingredientesStream.add(ingredientes);
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
             Text('Ingredientes'),
             SizedBox(height: 5,),
            StreamBuilder<List<String>>(
  stream: _ingredientesStream.stream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
       return Container(
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Center(child: Text("Nenhum ingrediente adicionado.")));
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Center(child: Text("Nenhum ingrediente adicionado.")));
    }

    final ingredientes = snapshot.data!;

  return ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: ingredientes.length,
  itemBuilder: (context, index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(6.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    "${index + 1}º ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Text(
                      ingredientes[index],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  ingredientes.removeAt(index);
                  _ingredientesStream.add(ingredientes);
                });
              },
            ),
          ],
        ),
      ),
    );
  },
);

  },
),


           
      
               
                   Padding(
               padding: EdgeInsets.only(left: 60, right: 60, top: 16),
                    child: MyButton(
                       onTap:(){ _adicionarIngOrHowMake("ing");}, text: 'Adicionar Ingrediente', ),
                  ),
                
              
        


    
          


            // Imagem do alimento

            SizedBox(height: 16),

           Text('Passo a Passo'),
             SizedBox(height: 5,),
            StreamBuilder<List<String>>(
  stream: _HowMakeStream.stream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Center(child: Text("Nenhum passo adicionado."))); // Indicador de carregamento
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Center(child: Text("Nenhum passo adicionado.")));
    }

    final howMake = snapshot.data!;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: howMake.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          decoration: BoxDecoration(
          color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(6.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                       Text("${index + 1}º passo: ", style: TextStyle(fontWeight: FontWeight.bold),),
                      Flexible(
                        child: Text(" ${howMake[index]}",
                          style: TextStyle(
                            fontSize: 16,
                           
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      howMake.removeAt(index);
                      _HowMakeStream.add(howMake);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  },
),


           
      
               
                  Padding(
               padding: EdgeInsets.only(left: 60, right: 60, top: 16),
                    child: MyButton(
                       onTap:(){ _adicionarIngOrHowMake("how");}, text: 'Adicionar Passo', ),
                  ),

              SizedBox(height: 30),
            Center(
                child:
                    MyButton(onTap: 
                      _enviarFormulario
                    , text: 'Enviar Receita'))
          ],
        ),
      ),
    );
  }
}
