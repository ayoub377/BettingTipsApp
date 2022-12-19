import 'package:bettingtipsapp/auth/auth_screen.dart';
import 'package:bettingtipsapp/providers/auth_provider.dart';
import 'package:bettingtipsapp/providers/bottomnavbarprovider.dart';
import 'package:bettingtipsapp/screens/HomeScreen.dart';
import 'package:bettingtipsapp/screens/TipsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'SubscriptionScreen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  BottomNavBarProvider _bottomNavBarProvider = BottomNavBarProvider();
  AuthProvider _authProvider = AuthProvider();
  final _picker = ImagePicker();
  bool isImageSelected = false;
  late XFile image;
  TextEditingController username_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  String? username = '';
  String email = '';
  bool isLoading = false;
  String imageUrl = '';

  @override
  void initState() {
    User? user = _authProvider.auth.currentUser;
    username_controller.text = user?.displayName ?? '';
    email_controller.text = user?.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username_controller.dispose();
    email_controller.dispose();
  }


  Future<void> UploadImages() async
  {
    Reference data = _authProvider.storageRef.child("users_images/${path.basename(image.path)}");
    UploadTask uploadTask = data.putFile(io.File(image.path));
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
    String url = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  void ImageSelect() async
  {
    XFile? imagepicked = (await _picker.pickImage(source: ImageSource.gallery));
    setState(() {
      isImageSelected = !isImageSelected;
      image= imagepicked!;
    });
  }

  Future<void> UpdateProfile() async
  {
    await _authProvider.updateProfile(username_controller.text, email_controller.text, imageUrl);
  }

  BottomNavigationBar bottomNavBar() {
    Color bgColor = Colors.white;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Image.asset('assets/icons/accueil.png', width: 30, height: 30,),
          label: 'home',
        ),
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Icon(Icons.workspace_premium_rounded,),
          label: 'subscription',
        ),
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Image.asset('assets/icons/list.png', width: 30, height: 30,),
          label: 'tips',
        ),
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Image.asset('assets/icons/setting.png', width: 30, height: 30,),
          label: 'profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      elevation: _bottomNavBarProvider.elevation,
      currentIndex: _bottomNavBarProvider.currentIndex,
      selectedLabelStyle: TextStyle(
          color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
          color: Colors.white10, fontSize: 12, fontWeight: FontWeight.bold),
      onTap: (index) {
        _bottomNavBarProvider.changeIndex(index);
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomeScreen()), (route) => false);
            break;
          case 1:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>SubscriptionScreen()), (route) => false);
            break;
          case 2:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>TipsScreen()), (route) => false);
            break;
          case 3:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>EditProfileScreen()), (route) => false);
            break;
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepPurple
              ]

          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                   Container(
                    height: 250.0,
                    child:  Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                 Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Text('PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.black)),
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:  Stack(fit: StackFit.loose, children: <Widget>[
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              Container(
                              padding: EdgeInsets.only(top: 20),
                          height: 150,
                          width: 150,
                          child: FutureBuilder(
                            future: _authProvider.Get_CurrentUser_infos(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData)
                              {
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(snapshot.data.toString()),
                                );
                              }
                              else
                              {
                                if(isImageSelected)
                                {
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(io.File(image.path)),
                                  );
                                }
                                else
                                {
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage('assets/images/empty.jpg'),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                     CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: InkWell(
                                        onTap: () {
                                          ImageSelect();
                                        },
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                       Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[

                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                       Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Flexible(
                                    child:  TextField(
                                      controller: username_controller,
                                      decoration:  InputDecoration(

                                      ),

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Flexible(
                                    child:  TextField(
                                      controller: email_controller,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width:100,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                    ),
                                    onPressed: () async {
                                      await UploadImages();
                                      await UpdateProfile();
                                      _bottomNavBarProvider.changeIndex(0);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                                    },
                                    child: Text('Update',style: TextStyle(fontSize: 13),),
                                  ),
                                ),
                              ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width:100,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                  ),
                                  onPressed: () async {
                                    await _authProvider.signOut();
                                    Navigator.pushNamed(context, AuthScreen.routeName);
                                  },
                                  child: Text('LogOut',style: TextStyle(fontSize: 13),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }
}


