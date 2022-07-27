import 'dart:async';

import 'package:chat_app/widgets/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshots.hasData) {
          return Center();
        }
        return ListView.builder(
            reverse: true,
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (ctx, index) {
              return MessageBubble(
                snapshots.data!.docs[index]['username'],
                snapshots.data!.docs[index]['text'],
                snapshots.data!.docs[index]['userImage'],
                snapshots.data!.docs[index]['userId'] == user!.uid,
                key: ValueKey(snapshots.data!.docs[index].id),
              );
            });
      },
    );
  }
}
