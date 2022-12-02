import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //getting current user userid
    final user=FirebaseAuth.instance.currentUser;
    final userId=user!.uid;

    // final userData=FirebaseFirestore.instance.doc('user').collection(userId).get();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 233, 233),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                        
                              padding: EdgeInsets.all(10),
                              height: 203,
                              width: 170,
                              decoration: BoxDecoration(
                                //color: Colors.orange,
                                border: Border.all(color: Colors.blue),
                                // borderRadius: BorderRadius.all(
                                //   Radius.circular(200),
                                // ),
                              ),
                              child: Image.asset('assets/profile.png',fit: BoxFit.cover,),
                            ),
              ],
            ),
            Divider(
                height: 40,
                thickness: 1,
                color: Colors.blue,
              ),
              Container(
              padding: EdgeInsets.only(left: 25.0,right: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.people
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // Text(
                  //   userData.data['userName'],
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w400
                  //   ),
                  // )
                  FutureBuilder(
                //geting userName from user collection using userid
                future:FirebaseFirestore.instance.collection('user').doc(userId).get(),
                builder: (context, futuresnapshot) {
                  if(futuresnapshot.connectionState==ConnectionState.waiting){
                    return Text("Waaiting.....",textAlign: TextAlign.end,style: TextStyle(color: Colors.black),);
                  }
                  return Text(
                    futuresnapshot.data!['username'],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                    ),


                  );
                }

              ),
                ],
              ),
            ),
            Divider(
              height: 40,
              thickness: 1,
              color: Colors.blue,
            ),
             Container(
              padding: EdgeInsets.only(left: 25.0,right: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.mail
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // Text(
                  //   userData.data['userName'],
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w400
                  //   ),
                  // )
                  FutureBuilder(
                //geting userName from user collection using userid
                future:FirebaseFirestore.instance.collection('user').doc(userId).get(),
                builder: (context, futuresnapshot) {
                  if(futuresnapshot.connectionState==ConnectionState.waiting){
                    return Text("Waaiting.....",textAlign: TextAlign.end,style: TextStyle(color: Colors.black),);
                  }
                  return Text(
                    futuresnapshot.data!['email'],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                    ),


                  );
                }

              ),
                ],
              ),
            ),
             Divider(
              height: 40,
              thickness: 1,
              color: Colors.blue,
            ),

          ],
        ),
      ),
    );
  }
}