import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/login_scrren.dart';
import 'package:chat_app/Screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Screens/bottom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:bottom_navy_bar/bottom_navy_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await   Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading=false;
  //creating instance of FireBaseAuth
  final _auth=FirebaseAuth.instance;

  void _submitAuthForm(String userEmail,String userName,String userPassword,bool isLogin,BuildContext ctx,String imageUrl)async{
    UserCredential userCredential;
    try{
      setState(() {
        _isLoading=true;
      });
    if(isLogin){
         Center(child: CircularProgressIndicator(),);
         userCredential=await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
    }
    else{
      Center(child:CircularProgressIndicator(),);
      userCredential=await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

      //uplading image to Firebase Cloud
      // final ref=FirebaseStorage.instance.ref().child('user_image').child(userCredential.user!.uid+'.jpg');
      // await ref.putFile(image);
      //storing data of user table in cloud Firestore
      print("Main Screen${imageUrl}");
      await FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid).set({'username':userName,'email':userEmail,});


    }
    }on PlatformException catch(error){
      var message="An errror occured,please check your credentials";

      if(error.message!=null){
        message=error.message.toString();
      }
      final snackBar= SnackBar(
            content:  Text(message),backgroundColor: Theme.of(context).errorColor,);
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
       setState(() {
         _isLoading=false;
       });
    }catch(error){
      //showing snackBar 
      final snackBar= SnackBar(
            content:  Text(error.toString()),backgroundColor: Theme.of(context).errorColor,);
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      setState(() {
         _isLoading=false;
       });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   BottomDrawer.routeName:(context) => BottomDrawer(),
      // },
      home: Scaffold(
        //according to the state the below pages will be swap 
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, usersnapshot) {
        if(usersnapshot.hasData){
            return BottomDrawer(isLoading: _isLoading,);
            
          
        }
         _isLoading=false;
        return LoginScreen(_submitAuthForm,_isLoading);
        
      },)
      ),
    );
  }
}