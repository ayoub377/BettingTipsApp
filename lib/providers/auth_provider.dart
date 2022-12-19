import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userId;
  late String error_message;
  final storageRef = FirebaseStorage.instance.ref();


  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      notifyListeners();
       final credentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);
       User? user = credentials.user;
       userId = user!.uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', userId);
      notifyListeners();
      return true;
    } on PlatformException catch (error) {
      print(error.toString());
      notifyListeners();
      String message = error.code;
      if(error.code == 'ERROR_USER_NOT_FOUND'){
        message = 'User Not Found';
      }else if(error.code == 'ERROR_WRONG_PASSWORD'){
        message = 'Wrong Password';
      }else if(error.code == 'ERROR_INVALID_EMAIL'){
        message = 'Invalid Email';
      }
    }
  }

  Future<dynamic> registerWithEmailAndPassword(
      String email, String password) async {
    try {

      notifyListeners();
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password).then((value) async {
        FirebaseFirestore.instance.collection('Users')
            .doc(value.user?.uid)
            .set({
          'name': '',
          'email': email,
          'uid': value.user?.uid,
          'image': '',
          'isSubscribed':false
        });
      });

      notifyListeners();
      return true;
    } on PlatformException catch (error) {
      print(error.toString());

      notifyListeners();
      String message = error.code;
    }
  }

  Future signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', '');
      notifyListeners();
      return await auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

Future ResetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      notifyListeners();
      return true;
    } on PlatformException catch (error) {
      print(error.toString());
      notifyListeners();
      String message = error.code;
    }
  }

  Future<void> updateProfile(String name, String email, String image) async {
    User? user = auth.currentUser;
    user!.updateDisplayName(name);
    user.updateEmail(email);
    user.updatePhotoURL(image);
    FirebaseFirestore.instance.collection('Users')
        .doc(user.uid)
        .update({
      'name': name,
      'email': email,
      'image': image,
    });
  }

  Future<String> Get_CurrentUser_infos() async {
    User? user = auth.currentUser;
    var user_infos = await FirebaseFirestore.instance.collection('Users').where("uid", isEqualTo:user!.uid).get();
    return user_infos.docs.first['image'];
  }

}