import 'package:app_base/components/drawer.dart';
import 'package:app_base/pages/home_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:app_base/pages/profile_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final userCollection = FirebaseFirestore.instance.collection("Users");
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

  final currentUser = FirebaseAuth.instance.currentUser!;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Passo a passo",
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

            Center(child: Text('${widget.tituloReceita}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)),
        
                 Padding(
                   padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                   child: StreamBuilder<DocumentSnapshot>(
                                    stream: userCollection
                                        .doc(widget.quemPostou)
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
                                        return GestureDetector(
                                        onTap: ()=> goToProfilePage2(widget.quemPostou),
                                        child: Row(
                                          children: [
                                            Text("Por: ${userData['username']}", style: TextStyle(fontSize: 15),),
                                            SizedBox(width: 5,),
                                           ClipOval(
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            constraints: BoxConstraints(minHeight: 60),
                                            child:   Center(
                                        child: Icon(
                                      Icons.person,
                                      size: 35,
                                    ))
                                          ),
                                        ),
                                          ],
                                        ),
                                      );
                                      }
                               
                                      // Exibe a lista de comentários
                               
                                      return GestureDetector(
                                        onTap: ()=> goToProfilePage2(widget.quemPostou),
                                        child: Row(
                                          children: [
                                           Text("Por: ${userData['username']}", style: TextStyle(fontSize: 15),),
                                            SizedBox(width: 5,),
                                           ClipOval(
                                          child: Container(
                                            
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle
                                            ),
                                            constraints: BoxConstraints( maxHeight:45, minWidth: 45),
                                            child: Image.network(
                                              userData['photoUrl'],
                                              fit: BoxFit
                                                  .fill, // Preenche todo o espaço do container
                                              errorBuilder: (context, error, stackTrace) {
                                                return Center(
                                                    child: Icon(Icons
                                                        .error)); // Ícone de erro se a imagem não carregar
                                              },
                                            ),
                                          ),
                                        ),
                                          ],
                                        ),
                                      );
                                    },
                                  
                                 
                               ),
                 ),
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
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(FontAwesomeIcons.utensils,),
                              Text("INGREDIENTES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              Icon(FontAwesomeIcons.utensils),
                            ],
                            
                          ),
                          SizedBox(height: 15,),
                        Column(children: List.generate(widget.ingredientes.length, (index) {
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.symmetric(vertical: 5), // Espaçamento entre os containers
                                      color: const Color.fromARGB(255, 224, 224, 224),
                                      child: Row(
                                        children: [
                                        
                                         ClipOval(
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                  
                                      decoration: BoxDecoration(
                                        
                                        color: Colors.black
                                      ),

                                      child: Center(child: Text("${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white))),
                          
                        ),
                                          ),
                                         
                                          SizedBox(width: 10,),
                                          Text(
                        widget.ingredientes[index],
                        style: TextStyle(fontSize: 16),
                        softWrap: true,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),),
                      ],
                    )
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
                      children: [
                         SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(FontAwesomeIcons.pencil,),
                              Text("COMO FAZER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              Transform(
  alignment: Alignment.center,
  transform: Matrix4.rotationY(pi), // Inverte horizontalmente
  child: Icon(FontAwesomeIcons.pencil),
)

                            ],
                            
                          ),
                          SizedBox(height: 15,),
                        Column(
                          children: List.generate(widget.comoFazer.length, (index) {
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.symmetric(vertical: 5), // Espaçamento entre os containers
                                      color: const Color.fromARGB(255, 224, 224, 224),
                                      child: Row(
                                        children: [
                                           Text("${index + 1}º Passo: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, fontFamily: 'DancingScript',fontStyle: FontStyle.italic),),
                                          SizedBox(width: 5,),
                                          Column(
                                            children: [
                                              SizedBox(height: 5,),
                                              Text(
                                                                      widget.comoFazer[index],
                                                                      style: TextStyle(fontSize: 16),
                                                                      softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                        ),
                      
                      ],
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
