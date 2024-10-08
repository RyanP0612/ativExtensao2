import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300],
      borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // comentario
        Container(
    width: MediaQuery.of(context).size.width /1.4,  // Defina uma largura máxima para o Container
    child: Text(
      text,
      softWrap: true,  // Quebra o texto em várias linhas automaticamente
    ),
  
),

        const SizedBox(height: 5,),
        
        Row(
          children: [
            Text(user, style: TextStyle(color: Colors.grey[400]),),
            Text(" * ", style: TextStyle(color: Colors.grey[400]),),
            Text(time, style: TextStyle(color: Colors.grey[400]),),
          ],
        )
      ],),
    );
  }
}