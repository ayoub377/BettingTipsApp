import 'package:bettingtipsapp/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/reset-password';
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late AuthProvider _authProvider;
  TextEditingController emailController = TextEditingController();
   final _formKey = GlobalKey<FormState>();

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      _authProvider = Provider.of<AuthProvider>(context);
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
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  controller: emailController,
                  autofocus: true,
                  maxLines: 1,
                  expands: false,
                  keyboardType: TextInputType.emailAddress,
                  minLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Email', hintText: 'email@email.com'),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width:200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                         await _authProvider.ResetPassword(emailController.text).then((value) => {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Check your email for password reset link'))),
                             Navigator.pop(context)
                        }).catchError((error) => {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())))
                        });
                        }
                         },
                      child: Text('Reset Password'),
                    ),
                  ),
                ),
              ),

            ],
    ),
          ),
        ),
      );
   }
  }


//
// class ResetPasswordScreen extends StatefulWidget {
//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }
//
// class _LoginFormState extends State<ResetPasswordScreen> {
//   late AuthProvider _authProvider;
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool showPassword = false;
//

//   @override
//   Widget build(BuildContext context) {

// }