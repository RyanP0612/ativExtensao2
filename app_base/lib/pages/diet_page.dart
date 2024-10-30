import 'package:app_base/components/custom_carousel.dart';
import 'package:app_base/components/drawer.dart';
import 'package:app_base/pages/feed_diet_page.dart';
import 'package:app_base/pages/feed_page.dart';
import 'package:app_base/pages/form_receita_page.dart';
import 'package:app_base/pages/home_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage>  with SingleTickerProviderStateMixin {


   late final AnimationController _controller;

@override
void initState() {
  super.initState();
  
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1), // Defina a duração da animação
  );
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

  void goToHomePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }


  void signOut() {
    FirebaseAuth.instance.signOut();
  }


  Widget build(BuildContext context) {
    
  List<Widget> containerList = [
    GestureDetector(
      onTap: () {
        
        Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedDietPage()));
      },
      child: Container(
        padding: EdgeInsets.all(10), // Padding para espaçamento interno
        height: 60, // Aumentei a altura
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(15), // Bordas mais arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.6), // Sombra suavizada
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Melhor distribuição
            children: [
              Text(
                'Celíacos',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight
                        .w600), // Texto um pouco maior e negrito suave
              ),
              Icon(
                FontAwesomeIcons.breadSlice,
                color: Colors
                    .brown.shade700, // Cor mais escura para melhor contraste
                size: 28, // Ícone maior
              )
            ],
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.6),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Intolerantes a lactose',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white), // Texto em branco
              ),
              Icon(
                FontAwesomeIcons.cow,
                color: Colors.white, // Ícone branco para combinar com o fundo
                size: 28,
              )
            ],
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        print("neymar");
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Veggies',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white), // Texto em branco
              ),
              Icon(
                FontAwesomeIcons.leaf,
                color: Colors
                    .limeAccent.shade400, // Cor mais vibrante para o ícone
                size: 28,
              )
            ],
          ),
        ),
      ),
    ),
  ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Dietas",
          style:
              TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Adcionar receita?"),
                        content: Text(
                            "Clique em adicionar para preecher o formulário e adicionar sua receita!"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReceitaFormScreen()));
                              },
                              child: Text("Adicionar")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Fechar"))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add))
        ],

        foregroundColor: Colors.grey[300], //cor do drawer / gaveta
      ),
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onHomeTap: goToHomePage,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Colors.grey[900],),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                
                    color: Colors.green[800],
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.grey.shade600,
                    //       // spreadRadius: 2,
                    //       blurRadius: 50,
                    //       offset: const Offset(0, 15))
                    // ]
                    
                    ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Lottie.asset(
                    'assets/animations/alimentos.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      // Configure the AnimationController with the duration of the
                      // Lottie file and start the animation.
                      _controller
                        ..duration = composition.duration
                        ..forward();
                    },
                                ),
                                Container(
                                  height: 150,
                                  child: Lottie.asset(
                                                    'assets/animations/mulherPensando.json',
                                                   
                                                    controller: _controller,
                                                    
                                                    onLoaded: (composition) {
                                                      
                                                      // Configure the AnimationController with the duration of the
                                                      // Lottie file and start the animation.
                                                      _controller
                                                        ..duration = composition.duration
                                                        ..forward();
                                                    },
                                  ),
                                ),
                               
                                _controller.status.isCompleted? Icon(Icons.abc) : SizedBox()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Adapte receitas em casa!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            CustomCarousel(pages: containerList),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
