import 'package:app_base/components/drawer.dart';
import 'package:app_base/pages/home_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StepByStepPage extends StatefulWidget {
  final String postId;
  final String tituloReceita;
  final String imgURL;
  final String tipoReceita;
  final String saborReceita;
  final String ingredientes;
  final String comoFazer;
  final String quemPostou;

  const StepByStepPage(
      {super.key,
      required this.postId,
      required this.tituloReceita,
      required this.imgURL,
      required this.tipoReceita,
      required this.saborReceita,
      required this.ingredientes,
      required this.comoFazer,
      required this.quemPostou});

  @override
  State<StepByStepPage> createState() => _StepByStepPageState();
}

class _StepByStepPageState extends State<StepByStepPage> {
  
  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
 void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToHomePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  String _formatarTextoHowMake(String texto) {
    return texto
        // Adiciona uma nova linha antes de cada número que indica um passo
        .replaceAllMapped(RegExp(r'(\d)([A-Z])'), (match) {
          return '\n\n' + match.group(0)!;
        })
        .replaceAllMapped(RegExp(r'(\d)([a-z])'), (match) {
          return '\n' + match.group(0)!;
        })
        .trim(); // Remove espaços extras no começo e fim.
  }

 String _formatarTextoIngredient(String texto) {
  return texto
      // Adiciona quebra de linha antes de medidas como "g", "kg", "ml", "colheres", etc.
      .replaceAllMapped(
          RegExp(r'(\d+)\s*(g|kg|ml|colheres?|ovos?|xícaras?|%|L)', caseSensitive: false),
          (match) {
        return '\n' + match.group(1)! + ' ' + match.group(2)!; // Mantém a medida e número juntos
      })
      // Adiciona uma nova linha antes de frases começando com "Para" para separar seções
      .replaceAllMapped(RegExp(r'(Para\s+[a-zA-Z]+)', caseSensitive: false), (match) {
        return '\n\n' + match.group(0)!;
      })
      // Adiciona uma nova linha após o nome do ingrediente
      .replaceAllMapped(RegExp(r'(\d+)\s*[a-zA-Z]', caseSensitive: false), (match) {
        return match.group(0)! + '\n';
      })
      // Adiciona quebra de linha após palavras específicas como "g", "colheres", etc.
      .replaceAllMapped(
          RegExp(r'(\d+\s*[a-zA-Z]+)\s*(g|kg|ml|colheres?|ovos?|xícaras?|%)', caseSensitive: false),
          (match) {
        return match.group(1)! + '\n' + match.group(2)!;
      })
      .trim(); // Remove espaços em branco extras no começo e fim.
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
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                    // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                 color: Colors.black,
                          // borderRadius: BorderRadius.circular(15),
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
                      
                        padding: EdgeInsets.all(65),
                ),
              ],
            ),
            SizedBox(height: 15,),
            
            Padding(
              padding: const EdgeInsets.all(35),
              child: Container(
                width: MediaQuery.of(context).size.width /2,
                color: Colors.black,
                padding: EdgeInsets.all(3),
               
                child: Container(
                   padding: EdgeInsets.all(5),
                  color:  const Color.fromARGB(255, 224, 224, 224),
                    width: MediaQuery.of(context).size.width /1.5,  // Defina uma largura máxima para o Container
                    child: Text(
                      _formatarTextoIngredient(widget.ingredientes),
                      softWrap: true,  // Quebra o texto em várias linhas automaticamente
                    ),
                  ),
              ),
            ),
            SizedBox(height: 15,),
            
            Padding(
              padding: const EdgeInsets.all(35),
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(3),
               
                child: Container(
                   padding: EdgeInsets.all(5),
                  color:  const Color.fromARGB(255, 224, 224, 224),
                    width: MediaQuery.of(context).size.width /1.5,  // Defina uma largura máxima para o Container
                    child: Text(
                      _formatarTextoHowMake(widget.comoFazer),
                      softWrap: true,  // Quebra o texto em várias linhas automaticamente
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
