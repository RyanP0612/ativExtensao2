import 'package:app_base/components/alt_button.dart';
import 'package:app_base/components/drawer.dart';
import 'package:app_base/pages/diet_page.dart';
import 'package:app_base/pages/feed_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
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
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Home",
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        // spreadRadius: 2,
                        blurRadius: 50,
                        offset: const Offset(0, 15))
                  ]),
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/fundo.png",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    AltButton(
                      onTap: goToFeedPage,
                      icon: Icons.article_rounded,
                      colorBG: Colors.blueAccent,
                      colorIcon: Colors.white,
                    ),
                    Text(
                      "Feed",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    AltButton(
                      onTap: goToDietPage,
                      icon: Icons.restaurant_menu,
                      colorBG: Color.fromARGB(255, 238, 101, 10),
                      colorIcon: Colors.white,
                    ),
                    Text(
                      "Dietas",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    AltButton(
                      onTap: () {},
                      icon: Icons.date_range_rounded,
                      colorBG: Color.fromARGB(255, 187, 17, 17),
                      colorIcon: Colors.white,
                    ),
                    Text(
                      "Cardápio",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
