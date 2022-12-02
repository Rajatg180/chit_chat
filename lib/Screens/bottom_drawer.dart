import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/chat_screen.dart';
import '../Screens/profile_screen.dart';


class BottomDrawer extends StatefulWidget {
  static const routeName='/bottom-drawer';
  //final Function(bool isLoading) isLoadingFn;
  // BottomDrawer({required this.isLoadingFn});
  bool isLoading;
  BottomDrawer({required this.isLoading});
  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  late List<Map<String,dynamic>> _page;

  int _selectedPageIndex=0;

  void initState(){
  _page=[
    {'page':ChatScreen(),'title':'Chit Chat'},
    {'page':ProfileScreen(),'title':'Profile'},
  ];
  super.initState();
  }


  void _selectedPage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedPageIndex]['page'],
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(_page[_selectedPageIndex]['title']),
          actions: [
            DropdownButton(
              icon: Icon(Icons.more_vert,color: Colors.white,),
              items: [
                DropdownMenuItem(
                  value:'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app,color: Colors.blue,),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Logout")
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: ((iteamIdentifier) {
                if(iteamIdentifier=='logout'){
                  FirebaseAuth.instance.signOut();
                  widget.isLoading=true;
                }
                
              }
            ),
      )],

        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          onTap: _selectedPage,
          unselectedItemColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 197, 223, 244),
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.message),
             label: "Chat",
             
            ),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle) ,
            label: "Profile")
          ],

        ),
    );
  }
}