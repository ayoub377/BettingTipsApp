import 'package:bettingtipsapp/auth/auth_screen.dart';
import 'package:bettingtipsapp/providers/auth_provider.dart';
import 'package:bettingtipsapp/screens/dashboard_screen.dart';
import 'package:bettingtipsapp/widgets/internet_not_connected.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import '../core/themes.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {


  final AuthProvider _authProvider = AuthProvider();
  final _picker = ImagePicker();
  bool isImageSelected = false;
  late XFile image;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? username = '';
  String email = '';
  bool isLoading = false;
  String imageUrl = '';

  @override
  void initState() {
    User? user = _authProvider.auth.currentUser;
    usernameController.text = user?.displayName ?? '';
    emailController.text = user?.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
  }


  Future<void> uploadImages() async
  {
    Reference data = _authProvider.storageRef.child("users_images/${path.basename(image.path)}");
    UploadTask uploadTask = data.putFile(io.File(image.path));
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
    String url = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  void imageSelect() async
  {
    XFile? imagepicked = (await _picker.pickImage(source: ImageSource.gallery));
    setState(() {
      isImageSelected = !isImageSelected;
      image= imagepicked!;
    });
  }

  Future<void> updateProfile() async
  {
    await _authProvider.updateProfile(usernameController.text, emailController.text, imageUrl);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title:Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text('PROFILE', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'sans-serif-light',
                            color: Colors.white)),
                  ),
                  InkWell(
                      onTap: () async {
                        await _authProvider.signOut();
                        if(mounted)
                        {
                          Navigator.pushNamed(context, AuthScreen.routeName);
                        }
                      },
                      child: const Icon(Icons.logout))
                ],
              )),
          elevation: 0,
          backgroundColor: const Color(0xff405cbf),
        ),
      ),
      body: Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.connected ? ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
               SizedBox(
                height: 250.0,
                child:  Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child:  Stack(fit: StackFit.loose, children: <Widget>[
                     Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Container(
                      padding: const EdgeInsets.only(top: 20),
                  height: 150,
                  width: 150,
                  child: FutureBuilder(
                    future: _authProvider.getCurrentUserInfos(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        if(snapshot.data!.isNotEmpty){
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                snapshot.data.toString()),
                          );
                        }
                      if (isImageSelected) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(io.File(image.path)),
                          );
                        }
                      }
                      return const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/empty.jpg'),
                      );
                    },
                  ),
                ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 90.0, right: 100.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 25.0,
                              child: InkWell(
                                onTap: () {
                                  imageSelect();
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
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                 const Center(
                    child: Text(
                     'Personal Information',
                     style: TextStyle(
                         fontSize: 18.0,
                         fontWeight: FontWeight.bold),
                       ),
                  ),
                     Padding(
                       padding: const EdgeInsets.only(left: 20.0),
                       child: SizedBox(
                         width: 300,
                         child: TextField(
                           controller: usernameController,
                           decoration:  const InputDecoration(
                             label: Text("Name"),
                             labelStyle: TextStyle(
                               color: AppTheme.themeColor
                             )
                           ),
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 20.0),
                       child: SizedBox(
                         width: 300,
                         child: TextField(
                           controller: emailController,
                           decoration: const InputDecoration(
                               label: Text("Email"),
                               labelStyle: TextStyle(
                                 color: AppTheme.themeColor
                               )
                           ),
                         ),
                       ),
                     ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width:150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppTheme.themeColor),
                        ),
                        onPressed: () async {
                          await EasyLoading.show();
                          if(isImageSelected)
                          {
                            await uploadImages();
                          }
                          await updateProfile();
                          EasyLoading.dismiss();
                        },
                        child: const Text('Update',style: TextStyle(fontSize: 13),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Subscription status:"),
                  const SizedBox(height: 5,),
                  const Text("Non subscribed"),
                  const SizedBox(height: 20,),
                  const Center(child: Text("Your Bet tracking History",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),),
                  const SizedBox(height: 15,),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)
                      ),
                        onPressed: (){
                      Navigator.push(context,MaterialPageRoute (
                        builder: (BuildContext context) => const Dashboard(),
                      ) );
                    }, child: const Text("Go to Dashboard",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),)),
                  )

                ],
              ),
            ],
          ),
        ],
      ) : const InternetNotAvailable(),
    );
  }
}


