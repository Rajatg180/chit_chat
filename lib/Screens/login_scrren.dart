import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/Screens/user_image_picker.dart';
import 'package:flutter/material.dart';
import '../Screens/bottom_drawer.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.submitFn,this.isLoading);
  final bool isLoading;
  final void Function(String userEmail,String userName,String userPassword,bool isLogin,BuildContext ctx,String imageUrl) submitFn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  //creating global key for form widget 
  final _formKey=GlobalKey<FormState>();

  //creating a variable to check in which place we are currently 
  var _islogin=true;
  //creating variable to store data which we get from user 
  var _userEmail="";
  var _userUserName="";
  var _userPassword="";
  String? imageUrl;

  //function to get pickedImage

  // void pickedImage(File image){
  //   _userImageFile=image;
  // }
  


  
  File?  _pickedImage;
  Future<void> _pickImage()async {
     final ImagePicker _picker = ImagePicker();
     final pickedImage=await _picker.pickImage(source: ImageSource.gallery);
     if(pickedImage==null){
      return ;
     }
     setState(() {
       _pickedImage=File(pickedImage.path);
     }); 
     String dataTime=DateTime.now().toString();
     //getting ref to storage root
     Reference referenceRoot=FirebaseStorage.instance.ref();
     Reference referenceDirImage=referenceRoot.child('images');

     Reference refImageToUpload=referenceDirImage.child('$dataTime');
    
     try{
      print("Uploading to store");
       //store to file
     await refImageToUpload.putFile(_pickedImage as File);

      imageUrl=await refImageToUpload.getDownloadURL();
     //get url to the the image
     

     print("User Image Input Page:${imageUrl}");
     //await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({'image_url':widget.imageUrl});


     }catch(e){
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${e}");
     }
  }


  void _trySubmit(){
    //checking if all validator return null value or not 
    final isValid=_formKey.currentState!.validate();

    //close the keyboard as soon as we click submit button 
    FocusScope.of(context).unfocus();

    //if image is not clicked it will show snackBar
    // if(_userImageFile==null && !_islogin){
    //   final snackBar= SnackBar(
    //         content:  Text("No Image Picked"),backgroundColor: Theme.of(context).errorColor,);
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   return;
    // }
    if(isValid ){
      print("login Page ${imageUrl}");
      //if all validator return null value then we can save data 
      _formKey.currentState!.save();
      //passing argument to that function
      //trim will remove 
      widget.submitFn(_userEmail.trim(),_userUserName.trim(),_userPassword.trim(),_islogin,context,imageUrl.toString());
      //moving to chat screen 
      // Navigator.of(context).pushReplacementNamed(BottomDrawer.routeName);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // width: double.infinity,
                // child: Image.asset("assets/chat.jpg")
                child: Text("Chit Chat",style: TextStyle(
                  color: Colors.blue,
                  fontSize: 50,
                  fontWeight: FontWeight.w500
                ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.all(20),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      
                      children: [
                        if(!_islogin) Column(
                  children: [
                  Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                   decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(100),
                   border: Border.all(color: Colors.blueAccent)
                   
                   ),
                   //child: CircleAvatar(backgroundImage: FileImage(_pickedImage as File),)
                   child: _pickedImage!=null? Image.file(_pickedImage as File,fit: BoxFit.cover,):Center(child: Text("No Image Selected "),)
                  ),
                  TextButton.icon(
                    icon: Icon(
                       Icons.image,
                          color: Colors.blue,
                     ),
                    label: Text("Add Image",style: TextStyle(color: Colors.blue),),
                    onPressed: _pickImage,
                          
                  ),
                ],
            ),
                        SizedBox(
                          height: 20,
                        ),


                        TextFormField(
                          //givin key to each TextFormFiled will uniquely identify each widget
                          key: ValueKey('Email'),
                          //checking the field is valid or not
                          validator: (value) {
                            if(value!.isEmpty || !value.contains('@') ){
                              return "Enter Valid Email Address";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                          ),

                          //this method exectue only when the validator return null
                          onSaved:((emailValue) {
                            _userEmail=emailValue.toString();
                          }),
                                  
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //username field will only be visible when we are in register page 
                        if(!_islogin)
                          TextFormField(
                            key: ValueKey('UserName'),
                          //checking for valid username
                            validator: (value) {
                            if(value!.isEmpty || value.length<5){
                              return "Please Enter Atlest 5 Characters UserName";
                            }
                            return null;
                            },
                            decoration: InputDecoration(
                              labelText: "UserName",
                            ),
                            onSaved:((userNameValue) {
                            _userUserName=userNameValue.toString();
                            }),
                                  
                          ),

                        
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          key: ValueKey('Password'),
                          //checking for valid password
                          validator: (value) {
                            if(value!.isEmpty || value.length<7){
                              return "Please Enter Atleast 7 Characters Password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          //hide password from user
                          obscureText: true,
                          onSaved:((PasswordValue) {
                            _userPassword=PasswordValue.toString();
                          }),
                                  
                        ),
                                  
                        
                         SizedBox(
                          height: 20,
                        ),
                        if(widget.isLoading)
                        CircularProgressIndicator(),
                       if(!widget.isLoading)
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _trySubmit,
                           child: Text(
                            (_islogin)?"Login":"Register",
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )
                            )
                          ),
                        ),
                         SizedBox(
                          height: 20,
                        ),
                        if(!widget.isLoading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text((_islogin)?"Don't have an Account ? ":"Already have a Account"),
                            TextButton(onPressed: (() {
                              setState(() {
                              _islogin=!_islogin;
                            });}), child: Text((_islogin)?"Register":"Login",style: TextStyle(color: Colors.blue),))
                          ],
                        )
                         
                                  
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}