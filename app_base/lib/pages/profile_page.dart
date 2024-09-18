import 'package:app_base/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// Pega o usuário atual autenticado usando o Firebase Authentication
final currentUser = FirebaseAuth.instance.currentUser!;

// Referência para a coleção "Users" no Firestore, onde os documentos dos usuários são armazenados
final userCollection = FirebaseFirestore.instance.collection("Users");

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
        "Editar " + field, // Título do diálogo, informando qual campo será editado
        style: TextStyle(color: Colors.white), // Texto branco para o título
      ),
      
      // TextField para o usuário inserir o novo valor
      content: TextField(
        autofocus: true, // Faz o campo ser focado automaticamente ao abrir o diálogo
        style: TextStyle(color: Colors.white), // Cor branca para o texto inserido
        decoration: InputDecoration(
          hintText: "Entre com novo $field", // Placeholder para o campo de texto
          hintStyle: TextStyle(color: Colors.white), // Cor branca para o placeholder
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
          onPressed: () => Navigator.pop(context), // Fecha o diálogo sem fazer nada
          child: Text(
            "Cancelar", 
            style: TextStyle(color: Colors.white), // Cor branca para o texto do botão
          ),
        ),

        // Botão de salvar
        TextButton(
          // Fecha o diálogo e retorna o valor inserido pelo usuário
          onPressed: () => Navigator.of(context).pop(newValue), 
          child: Text(
            "Salvar", 
            style: TextStyle(color: Colors.white), // Cor branca para o texto do botão
          ),
        ),
      ],
    ),
  );

  // Se o valor inserido não for vazio ou não contiver apenas espaços
  if (newValue.trim().length > 0) {
    // Faz um update no documento do usuário no Firestore
    // O campo especificado (passado como argumento) é atualizado com o novo valor
    await userCollection.doc(currentUser.email).update({field: newValue});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Perfil",
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
  stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
builder: (context, snapshot) {
  
// get user data
if(snapshot.hasData){
  final userData = snapshot.data!.data() as Map<String, dynamic>;
  return
  ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          // foto de perfil
          Icon(
            Icons.person,
            size: 72,
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
          ),
          // bio
          MyTextBox(
            text: userData['bio'],
            sectionName: 'bio',
            onPressed: () => editField('bio'),
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

}
else if(snapshot.hasError){

  return Center(child: Text(
    'ERRO ${snapshot.error}!', style: TextStyle(color: Colors.red, fontSize: 20),
  ),
  );

}
return  Center(child: CircularProgressIndicator());
}

    )
    );
  }
}
