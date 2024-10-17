import 'package:app_base/components/my_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onProfileTap;
  final void Function()? onHomeTap;
  final void Function()? onSignOut;
  MyDrawer({super.key, required this.onProfileTap, required this.onSignOut, required this.onHomeTap});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              DrawerHeader(
                child: Center(
                  child: ClipOval(
                    child: Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey[
                          300], // Cor de fundo caso a imagem demore para carregar
                      child: currentUser.photoURL != null
                          ? Image.network(
                              currentUser.photoURL!,
                              fit: BoxFit
                                  .cover, // Preenche todo o espaço do container
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.error,
                                  size: 72,
                                  color: Colors
                                      .red, // Ícone em caso de erro no carregamento da imagem
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              size: 72,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),

              // home list title
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: widget.onHomeTap,
              ),
              // profile list tile
              MyListTile(
                icon: Icons.person,
                text: 'P E R F I L',
                onTap: widget.onProfileTap,
              ),
            ],
          ),
          // logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.exit_to_app,
              text: 'L O G O U T',
              onTap: widget.onSignOut,
            ),
          )
        ],
      ),
    );
  }
}
