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
  final List<String> ingredientes;
  final List<String> comoFazer;
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
      // drawer: MyDrawer(
      //   onProfileTap: goToProfilePage,
      //   onSignOut: signOut,
      //   onHomeTap: goToHomePage,
      // ),
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
              padding: const EdgeInsets.all(20),
              child: Container(
                width: MediaQuery.of(context).size.width /2,
                color: Colors.black,
                padding: EdgeInsets.all(3),
               
                child: Container(
                   padding: EdgeInsets.all(5),
                  color:  const Color.fromARGB(255, 224, 224, 224),
                    width: MediaQuery.of(context).size.width /1.5,  // Defina uma largura máxima para o Container
                    child: Column(children: List.generate(widget.ingredientes.length, (index) {
            return Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(vertical: 5), // Espaçamento entre os containers
              color: const Color.fromARGB(255, 224, 224, 224),
              child: Row(
                children: [
                  Text("${index + 1}º ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  SizedBox(width: 5,),
                  Text(
                    widget.ingredientes[index],
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                ],
              ),
            );
          }),)
                  ),
              ),
            ),
     
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(3),
               
                child: Container(
                   padding: EdgeInsets.all(5),
                  color:  const Color.fromARGB(255, 224, 224, 224),
                    width: MediaQuery.of(context).size.width /1.5,  // Defina uma largura máxima para o Container
                    child: Column(
                      children: List.generate(widget.comoFazer.length, (index) {
            return Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(vertical: 5), // Espaçamento entre os containers
              color: const Color.fromARGB(255, 224, 224, 224),
              child: Row(
                children: [
                   Text("${index + 1}º passo: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  SizedBox(width: 5,),
                  Text(
                    widget.comoFazer[index],
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                ],
              ),
            );
          }),
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
