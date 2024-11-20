import 'package:app_base/components/alt_button.dart';
import 'package:app_base/components/drawer.dart';
import 'package:app_base/pages/diet_page.dart';
import 'package:app_base/pages/feed_page.dart';
import 'package:app_base/pages/profile_page.dart';
import 'package:app_base/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 late final AnimationController _controller;

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
        backgroundColor: AppTheme.cor6,
        centerTitle: true,
        title: Text(
          "Home",
          style:
              TextStyle(color:AppTheme.cor1, fontWeight: FontWeight.bold),
        ),

        actions: [],

        foregroundColor: AppTheme.cor1, //cor do drawer / gaveta
      ),
      backgroundColor:  AppTheme.cor1,
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onHomeTap: goToHomePage,
      ),
      body: Center(
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
            SizedBox(
              height: 25,
            ),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    AltButton(
                      onTap: goToDietPage,
                      icon: LucideIcons.utensilsCrossed,
                      colorBG: AppTheme.cor5,
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
                      icon: LucideIcons.calendar,
                      colorBG: AppTheme.cor4,
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
            ),
            
          ],
        ),
      ),
    );
  }
}
