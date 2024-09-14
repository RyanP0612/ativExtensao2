import 'package:app_base/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          // header
const DrawerHeader(child: Icon(Icons.person, color: Colors.white, size: 64,)),

          // home list title
MyListTile(icon: Icons.home, text: 'H O M E', onTap: () => Navigator.pop(context),)
          // profile list tile

          // logout list tile
        ],
      ),
    );
  }
}