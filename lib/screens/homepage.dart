import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speak_sphere/backend_services/auth_services.dart';
import 'package:speak_sphere/backend_services/database_services.dart';
import 'package:speak_sphere/screens/search_page.dart';

import '../backend_services/helper_functions.dart';
import '../widgets/group_tile.dart';
import '../widgets/helper_widgets.dart';
import 'login_page.dart';
import 'profile_page.dart'; // Import ProfilePage if not already imported


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController createGroupNameController=TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;
  User currentUser= FirebaseAuth.instance.currentUser!;
  String userName = "";
  String email = "";
  AuthServices authServices = AuthServices();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  void initState(){
    super.initState();
    gettingAllUserData();
  }



  gettingAllUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email=value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value){
      setState(() {
        userName=value!;
      });
    });
    await DatabaseServices(uid:auth.currentUser?.uid).gettingUserGroups().then((snapshots){
      setState(() {
        groups=snapshots;

      });

    });
  }
  
  separateGroupId(String groupId){
    return groupId.substring(0,groupId.indexOf("_"));

    
  }
  separateGroupName(String groupId){
    return groupId.substring(groupId.indexOf("_")+1);


  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
          },
        foregroundColor: Colors.white,
        child: Icon(Icons.add),

      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(
                Icons.search,
              ))
        ],


        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            "SpeakSphere",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      drawer: Drawer(

        backgroundColor: Theme.of(context).colorScheme.primary,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.white,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).colorScheme.primary,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group,color: Colors.white,),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(
                  context,
                  ProfilePage(userName: userName, email: email,
                  ),
                );
              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person,color: Colors.white,),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authServices.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                                  (route) => false,
                            );
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app,color: Colors.white,),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body:userGroupList(),
    );
  }

  userGroupList(){
    return StreamBuilder(
      stream:groups ,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups'].length!=null){
            if(snapshot.data['groups'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context,index){
                  return GroupTile(
                      groupId: separateGroupId(snapshot.data['groups'][index]),
                      groupName: separateGroupName(snapshot.data['groups'][index]),
                      userName: snapshot.data['fullName']);
                  },
              );
            }else{
              return noGroupWidget();
            }

          }else{
            return noGroupWidget();
          }

        }else{
          return Center(
            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,),
          );
        }
      },
    );

  }
  popUpDialog(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Create a Group"),
        content: _isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,))

        :TextField(
          controller: createGroupNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
          actions:[
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();

            }, child: Text("Cancel",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor:Theme.of(context).colorScheme.primary),),
            ElevatedButton(onPressed: () async{
              if(createGroupNameController.text.toString()!=""){
                setState(() {
                  _isLoading=true;
                });
                await DatabaseServices(uid:currentUser.uid).createGroup(userName, createGroupNameController.text.toString());
                setState(() {
                  _isLoading=false;
                });
                Navigator.of(context).pop();
                showSnackbar(
                    context, Colors.green, "Group created successfully.");
              }


            }, child: Text("Create",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor:Theme.of(context).colorScheme.primary),)

          ],

      );
    });
  }
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void nextScreenReplace(BuildContext context, Widget nextPage) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }
}



