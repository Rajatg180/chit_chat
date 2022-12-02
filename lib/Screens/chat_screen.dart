import 'package:chat_app/Screens/message_bubble.dart';
import 'package:chat_app/Screens/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 233, 233),
      //getting data from database
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                //ordering message by RecivedAt field 
                stream: FirebaseFirestore.instance.collection('chats').orderBy('RecivedAt',descending: true).snapshots(),
                builder:((context, streamsnapshot) {
                  //show circular indicator until data get fetch
                  if(streamsnapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documents=streamsnapshot.data!.docs;
                  final user=FirebaseAuth.instance.currentUser;
                
                    return FutureBuilder( 
                      // future: FirebaseFirestore.instance.collection('chats').snapshots(),
                      builder:(ctx,futureSnapShot) {
                        if(futureSnapShot.connectionState==ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return ListView.builder(
                            reverse: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final userName=FirebaseFirestore.instance.collection('user').doc(documents[index]['userId']).get();
                              return MessageBubble(message:documents[index]['text'],isMe: documents[index]['userId']==user!.uid,userId: documents[index]['userId']);}
                            );
                      }
                    );
                  }
                ) ,
                ),    
        ),
        NewMessage(),
        ],
        ),
      ),
        //adding data to the backend 
        // floatingActionButton: FloatingActionButton(
        // onPressed: (() {
        //   //adding data to the chats table
        //   // FirebaseFirestore.instance.collection('chats').add({'here':"This is your Birthday"});
        //  // adding data to the message table
        //   FirebaseFirestore.instance.collection('chats/0gg9XRiHC1vCoynLp1ou/messages').add({'text':"This is added by the user"});
        // }),
        // child: Icon(Icons.add),
        // ),
        

        );

      
  }
}