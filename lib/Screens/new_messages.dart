import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> { 
  //using controller to clear message
  final _controller=new TextEditingController();
  var _enteredMessage="";
  void _sendMessage()async{
    //to close the keyboard
    FocusScope.of(context).unfocus();
    //geting user id from firebase auth 
    final user =FirebaseAuth.instance.currentUser;
    

    FirebaseFirestore.instance.collection('chats').add({'text':_enteredMessage,'RecivedAt':DateTime.now(),'userId':user!.uid});
    // setState(() {
    //   _enteredMessage="";
    // });
    //claering message after send button is pressed
    _controller.clear();
  }
  @override
  Widget build(BuildContext context) {  
    return Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: "Send a Message....."),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage=value;
                    });
                  },
                )
              ),
              IconButton(
                onPressed: _enteredMessage.trim().isEmpty ? null : (() {_sendMessage();}),
               icon: Icon(Icons.send))

            ],
          ),
  //         
        );
        
  }
}