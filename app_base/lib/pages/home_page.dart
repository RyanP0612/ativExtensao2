import 'dart:math';

import 'package:app_base/components/alt_button.dart';
import 'package:app_base/components/drawer.dart';
import 'package:app_base/pages/diet_page.dart';
import 'package:app_base/pages/feed_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:app_base/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
final List<Map<String, dynamic>> dicas = [
    {
      "texto": "Alimente-se bem",
      "icone": FontAwesomeIcons.appleWhole,
      "color": Colors.red
    },
    {
      "texto": "Beba mais água",
      "icone": FontAwesomeIcons.water,
       "color": Colors.blue
    },
    {
      "texto": "Faça exercícios regularmente",
      "icone": FontAwesomeIcons.dumbbell,
       "color": Colors.black
    },
    {
      "texto": "Durma bem à noite",
      "icone": FontAwesomeIcons.moon,
       "color": Colors.yellow
    },
    {
      "texto": "Evite alimentos processados",
      "icone": FontAwesomeIcons.utensils,
       "color": Colors.blueGrey
    },
    {
      "texto": "Coma mais fibras",
      "icone": FontAwesomeIcons.breadSlice,
       "color": AppTheme.cor5
    },
    {
      "texto": "Evite o açúcar em excesso",
      "icone": FontAwesomeIcons.candyCane,
      "color": Colors.red
    },
    {
      "texto": "Prefira alimentos frescos",
      "icone": FontAwesomeIcons.carrot,
       "color": Colors.orange
    },
  ];

  // Dica atual
  late Map<String, dynamic> dicaAtual;

class _HomePageState extends State<HomePage> {
  late final AnimationController _controller;

  @override
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    // Inicializa com uma dica aleatória
    dicaAtual = _getDicaAleatoria();
  }
  // Função para pegar uma dica aleatória
  Map<String, dynamic> _getDicaAleatoria() {
    final random = Random();
    return dicas[random.nextInt(dicas.length)];
  }
  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void goToFeedPage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedPage()));
  }

  void goToDietPage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DietPage()));
  }

  void goToHomePage() {
    Navigator.pop(context);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.cor6,
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(color: AppTheme.cor1, fontWeight: FontWeight.bold),
        ),

        actions: [],

        foregroundColor: AppTheme.cor1, //cor do drawer / gaveta
      ),
      backgroundColor: AppTheme.cor1,
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onHomeTap: goToHomePage,
      ),
        body: Column(
        children: [
          // Conteúdo principal
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cor6,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Bem-vindo(a)!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cor1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Encontre sua dieta ideal e acompanhe seu progresso.",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.cor1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Botões de navegação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          AltButton(
                            onTap: goToFeedPage,
                            icon: LucideIcons.newspaper,
                            colorBG: AppTheme.cor4,
                            colorIcon: Colors.white,
                          ),
                          Text(
                            "Feed",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          AltButton(
                            onTap: goToDietPage,
                            icon: LucideIcons.utensilsCrossed,
                            colorBG: AppTheme.cor4,
                            colorIcon: Colors.white,
                          ),
                          Text(
                            "Dietas",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          AltButton(
                            onTap: () {},
                            icon: LucideIcons.calendar,
                            colorBG: AppTheme.cor4,
                            colorIcon: Colors.white,
                          ),
                          Text(
                            "Cardápio",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  // Dicas rápidas
                  Padding(
                    padding: const EdgeInsets.all(35),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: AppTheme.cor6,
                          border: Border.all(width: 3, color: AppTheme.cor6),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Dicas rápidas:", style: TextStyle(color: AppTheme.cor1, fontSize: 16)),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.star, color: Colors.amber),
                              Icon(FontAwesomeIcons.star, color: Colors.amber),
                              Icon(FontAwesomeIcons.star, color: Colors.amber)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dica do dia
               Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dicaAtual = _getDicaAleatoria(); // Altera para uma dica aleatória ao tocar
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(minWidth: 10, minHeight: 30),
                        decoration: BoxDecoration(
                          color: AppTheme.cor2,
                          border: Border.all(width: 3, color: AppTheme.cor6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            children: [
                              Text(
                                dicaAtual["texto"],
                                style: TextStyle(color: AppTheme.cor6, ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                dicaAtual["icone"],
                                color:dicaAtual['color'],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    Column(
                      children: [
                        Text("☝🏽", style: TextStyle(fontSize: 30, ),),
                        Text("Clique acima", style: TextStyle(color: AppTheme.cor6,fontSize: 16),)
                      ],
                    ),
                    ],
                  ),
                ),
              ],
            ),
                ],
              ),
            ),
          ),
          // Rodapé fixo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
 
              child: Center(
                child: Text(
                  "Logado como ${currentUser.email}",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
