import 'package:bettingtipsapp/providers/bottomnavbarprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_form.dart';
import '../widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/authScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late AuthProvider _authProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                 child: Image.asset(
                   'assets/images/logo.png',
                   width: MediaQuery.of(context).size.width * 0.8,
                   fit: BoxFit.cover,
                 ),

              ),
              MaterialButton(
                onPressed: () {
                  showLoginSheet();
                },
                child: Text('Login'),
                minWidth: 250,
                color: Colors.deepOrange,
                textColor: Colors.white,
              ),
              MaterialButton(
                onPressed: () {
                  showSignUPSheet();
                },
                child: Text('Sign Up'),
                minWidth: 250,
                color: Colors.deepOrange,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSignUPSheet() {
    _scaffoldKey.currentState?.showBottomSheet(
          (BuildContext mContext) {
        return SignUpForm();
      },
      elevation: 20,
      backgroundColor: Colors.white,
    );
  }

  showLoginSheet() {
    _scaffoldKey.currentState?.showBottomSheet(
          (BuildContext mContext) {
        return LoginForm();
      },
      elevation: 20,
      backgroundColor: Colors.white,
    );
  }
}