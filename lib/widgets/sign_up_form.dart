import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/wrapper.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {

  late AuthProvider _authProvider;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;

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
        const SizedBox(height: 20),
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 180,
              child: Text(
                'Create new Account',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 28.5,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
        ),
        Center(child: GestureDetector(
             onTap: (){},
            child: const Text("Already Registered? Log in here."))),

        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: emailController,
            autofocus: true,
            maxLines: 1,
            expands: false,
            minLines: 1,
            decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black,fontSize: 14),
                labelText: 'Email', hintText: 'email@email.com'),
          ),
        ),
        (isLoading == true)?const Center(
          child: SizedBox(
            height: 40,
            child:CircularProgressIndicator(
              color: Color(0xff405cbf),
            ),
          ),
        ):Container(),
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
              labelStyle: const TextStyle(color: Colors.black,fontSize: 14),
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
        const SizedBox(height: 30),
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              style: const ButtonStyle(
                 backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
              ),
              onPressed:  () async {
                setState(() {
                  isLoading = true;
                });
                try{
                  await _authProvider.registerWithEmailAndPassword(
                      emailController.text, passwordController.text).whenComplete((){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute (builder: (BuildContext context) => const MainScreen()), (route) => false);
                  });
                }
                catch(e)
                {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("there is some problem try again"),));
                }
              },
              child: const Center(child: Text('Continue')),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}