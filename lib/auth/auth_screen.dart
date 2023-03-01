import 'package:bettingtipsapp/auth/register_screen.dart';
import 'package:flutter/material.dart';
import '../core/themes.dart';
import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/authScreen';

  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: Image.asset(
                     'assets/images/logo.png',
                     width: MediaQuery.of(context).size.width * 0.4,
                     fit: BoxFit.cover,
                   ),
                 ),

              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
                },
                minWidth: 250,
                color: AppTheme.themeColor,
                textColor: Colors.white,
                child: const Text('Login'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const RegisterScreen()));
                },
                minWidth: 250,
                color: AppTheme.themeColor,
                textColor: Colors.white,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}