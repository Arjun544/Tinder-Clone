import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_clone/models/contact_model.dart';
import 'package:tinder_clone/models/message_model.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/screens/chats_screen/components/online_indicator.dart';
import 'package:tinder_clone/screens/conversations_screen/conversations_screen.dart';
import 'package:tinder_clone/services/auth_methods.dart';
import 'package:tinder_clone/services/chat_methods.dart';

import 'dismiss_background.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: AuthMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatefulWidget {
  final UserModel contact;

  ViewLayout({
    @required this.contact,
  });

  @override
  _ViewLayoutState createState() => _ViewLayoutState();
}

class _ViewLayoutState extends State<ViewLayout> {
  final ChatMethods _chatMethods = ChatMethods();
  var docList;
  String docId;

  hasRead() async {
    for (int i = 0; i < docList.length; i++) {
      DocumentSnapshot docSnap = docList.last;
      docId = docSnap.id;
    }
    FirebaseFirestore.instance
        .collection('messages')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(widget.contact.uid)
        .doc(docId)
        .update({'hasRead': true});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        hasRead();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(
                receiver: widget.contact,
              ),
            ));
      },
      child: Dismissible(
        background: dismissBackground(), // Swipe to delete task from list
        key: UniqueKey(),
        onDismissed: (direction) {
          ChatMethods().deleteContact(
            FirebaseAuth.instance.currentUser.uid,
            widget.contact.uid,
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFFFF5864), width: 3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.network(
                                widget.contact.profilePhoto,
                                fit: BoxFit.cover,
                                height: 70,
                                width: 70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 6,
                      child: OnlineIndicator(
                        uid: widget.contact.uid,
                        isText: false,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: StreamBuilder(
                      stream: _chatMethods.fetchLastMessageBetween(
                          senderId: FirebaseAuth.instance.currentUser.uid,
                          receiverId: widget.contact.uid),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          docList = snapshot.data.docs;

                          if (docList.isNotEmpty) {
                            Message _message =
                                Message.fromMap(docList.last.data());
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      (widget.contact != null
                                                  ? toBeginningOfSentenceCase(
                                                      widget.contact.username)
                                                  : null) !=
                                              null
                                          ? toBeginningOfSentenceCase(
                                              widget.contact.username)
                                          : "..",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    _message.hasRead == false
                                        ? Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFF5864),
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                  ],
                                ),
                              ),
                              subtitle: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  _message.message,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _message.hasRead == true
                                      ? TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)
                                      : TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              trailing: Text(
                                DateFormat("h:mm a")
                                    .format(_message.timestamp.toDate()),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }

                          return Text(
                            "No Message",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          );
                        }
                        return Text(
                          "..",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        );
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.blueGrey.withOpacity(0.5),
              thickness: 2,
              indent: 100,
              endIndent: 14,
            ),
          ],
        ),
      ),
    );
  }
}
