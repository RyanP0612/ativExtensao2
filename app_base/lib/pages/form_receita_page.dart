import 'package:app_base/components/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReceitaFormScreen extends StatefulWidget {
  @override
  _ReceitaFormScreenState createState() => _ReceitaFormScreenState();
}

class _ReceitaFormScreenState extends State<ReceitaFormScreen> {
  // Controladores de estado
  String? tipoReceita; // Veggie, Intolerante a lactose, Celíaco
  String? saborReceita; // Café da manhã, Comida, Sobremesa
  File? _imagemSelecionada; // Imagem do alimento

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _comoFazerController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Função para selecionar imagem
  Future<void> _selecionarImagem() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  // Função para enviar o formulário
  void _enviarFormulario() {
    if (_tituloController.text.isNotEmpty &&
        tipoReceita != null &&
        saborReceita != null &&
        _ingredientesController.text.isNotEmpty &&
        _comoFazerController.text.isNotEmpty &&
        _imagemSelecionada != null) {
      // Exemplo de ação de envio (pode ser substituído por envio a um servidor, etc.)
      print("Formulário enviado!");
      print("Título: ${_tituloController.text}");
      print("Tipo: $tipoReceita");
      print("Sabor: $saborReceita");
      print("Ingredientes: ${_ingredientesController.text}");
      print("Como Fazer: ${_comoFazerController.text}");
      print("Imagem: ${_imagemSelecionada!.path}");
    } else {
      print("Preencha todos os campos");
    }
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
              controller: _tituloController,
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
