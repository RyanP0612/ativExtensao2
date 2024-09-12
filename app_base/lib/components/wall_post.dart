import 'package:app_base/components/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeticiaLindaPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const LeticiaLindaPost(
      {super.key, required this.message, required this.user, required this.postId, required this.likes});

  @override
  State<LeticiaLindaPost> createState() => _LeticiaLindaPostState();
}

class _LeticiaLindaPostState extends State<LeticiaLindaPost> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;


  @override

  void initState(){
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    // resolve o erro em likes: List<String>.from(post['Likes'] ?? []),
  }

  void toggledLike(){
    setState(() {
      isLiked = !isLiked;
    });
  }

    @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            children: [
// like button
              LikeButton(isLiked: isLiked, onTap:toggledLike),

// like count
            ],
          ),

          SizedBox(
            width: 20,
          ),
          // mensagem e email do usuario
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.message)
            ],
          ),
        ],
      ),
    );
  }
}
