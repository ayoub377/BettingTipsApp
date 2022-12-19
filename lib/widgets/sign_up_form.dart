import 'package:bettingtipsapp/providers/bottomnavbarprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/HomeScreen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late AuthProvider _authProvider;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  BottomNavBarProvider _bottomNavBarProvider = BottomNavBarProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Register',
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: emailController,
            autofocus: true,
            maxLines: 1,
            expands: false,
            minLines: 1,
            decoration: InputDecoration(
                labelText: 'Email', hintText: 'email@email.com'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: passwordController,
            autofocus: true,
            maxLines: 1,
            expands: false,
            obscureText: !showPassword,
            minLines: 1,
            decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'password',
                suffix: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    })),
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          onPressed:  () async {
            var result = await _authProvider.registerWithEmailAndPassword(
                emailController.text, passwordController.text);
            if (result is bool && result) {
              _bottomNavBarProvider.changeIndex(0);
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(result.toString()),
              ));
            }

          },
          child: Center(child: Text('Continue')),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}