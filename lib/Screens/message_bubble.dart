import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class MessageBubble extends StatelessWidget {
  
  MessageBubble({required this.message,required this.isMe,required this.userId});

  final bool isMe;
  final String message;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
        mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ?Color.fromARGB(255, 217, 247, 218): Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0):Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0):Radius.circular(12),
    
              ),
            ),
            width: 200,
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
            margin: EdgeInsets.symmetric(vertical:10,),
            child: Column(
              crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  //geting userName from user collection using userid
                  future:FirebaseFirestore.instance.collection('user').doc(userId).get(),
                  builder: (context, futuresnapshot) {
                    if(futuresnapshot.connectionState==ConnectionState.waiting){
                      return Text("Waaiting.....",textAlign: TextAlign.end,style: TextStyle(color: Colors.orange),);
                    }
                    return Text(
                      futuresnapshot.data!['username'],
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),
    
    
                    );
                  }
    
                ),
                Divider(
                  color: Colors.black,
                ),
             
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                  ),
    
                ),
    
              ],
            ),
          ),
        ],
      ),
      Positioned (
        top: 0,
        //left: 5,
        //right: 0,
        right: isMe? 0:null,
        width: 400,
        child: CircleAvatar(
           radius: 20.0,
    child: ClipRRect(
        child: Image.asset('assets/profile.png',fit: BoxFit.cover,),
        borderRadius: BorderRadius.circular(50.0),
    ),
          
        ),
      ),
      
  ],
  clipBehavior: Clip.none,
  );
  }
}