import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_screen.dart';
import '../providers/auth_provider.dart';
import 'HomeScreen.dart';

class Wrapper extends StatefulWidget {
  static final String routeName = 'appWrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late AuthProvider _authProvider;
  String _message = 'Getting User Data';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
    checkLogged().then((bool result) {
      if (result) {
        Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
      } else {
        // no user logged redirect to login screen
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 50),
              Text(_message)
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkLogged() async {
    WidgetsFlutterBinding.ensureInitialized();
    bool isUserLogged = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user');
    if (userId != null) {
      isUserLogged = true;
    }
    return isUserLogged;
  }


}