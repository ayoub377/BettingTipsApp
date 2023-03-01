import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userId;
  late String errorMessage;
  final storageRef = FirebaseStorage.instance.ref();
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;
  set isSubscribed(bool value) {
    _isSubscribed = value;
    notifyListeners();
  }

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
      if (kDebugMode) {
        print(error.toString());
      }
      notifyListeners();
      String message = error.code;
      if(message == 'ERROR_USER_NOT_FOUND'){
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
      await auth.createUserWithEmailAndPassword(
          email: email, password: password).then((value) async {
        FirebaseFirestore.instance.collection('Users')
            .doc(value.user?.uid)
            .set({
          'name': '',
          'isSubscribed':false,
          'email': email,
          'uid': value.user?.uid,
          'image': '',
        });
      });
      notifyListeners();
      return true;
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }

      notifyListeners();
    }
  }

  Future signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', '');
      notifyListeners();
      return await auth.signOut();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      notifyListeners();
      return true;
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      notifyListeners();
    }
  }

  Future<void> updateProfile(String name, String email, String? image) async {
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

  Future<String> getCurrentUserInfos() async {
    User? user = auth.currentUser;
    var userInfos = await FirebaseFirestore.instance.collection('Users').where("uid", isEqualTo:user!.uid).get();
    return userInfos.docs.first['image'];
  }

  Future<UserModel> getCurrentUser() async{
    User? user = auth.currentUser;
    var userInfos = await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();

    // Update the subscription status variable based on the value from Firestore
    isSubscribed = userInfos['isSubscribed'] ?? false;

    return UserModel.fromJson(userInfos.data()!);
  }

  void updateIsSubscribed(bool newValue) async {
    User? user = auth.currentUser;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    await docRef.update({'isSubscribed': newValue});

    // Update the subscription status variable after updating the value in Firestore
    isSubscribed = newValue;
  }


}




