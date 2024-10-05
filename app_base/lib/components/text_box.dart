import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final String sectionName;
  MyTextBox({super.key, required this.text, required this.sectionName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(8)
      ),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ 
              // section name
              Text(sectionName, style: TextStyle(color: Colors.grey[600]),),
              // botao de edição

              IconButton(onPressed: onPressed, icon: Icon(Icons.edit, color: Colors.grey[400],))
            ],
          ),
          // text
          Row(
            children: [
              Text(text),
            ],
          )
        ],
      ),
    );
  }
}