import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/contact_model.dart';
import 'package:tinder_clone/services/chat_methods.dart';
import 'components/contact_view.dart';
import 'components/quiet_box.dart';

class ChatsScreen extends StatelessWidget {
  final String userId;

  ChatsScreen({this.userId});

  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var docList = snapshot.data.docs;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}


