import 'package:bettingtipsapp/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {

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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/logo.png',width: MediaQuery.of(context).size.width * 0.2,),
            ),
          ),
        ),
         Center(
           child: Container(
             margin: const EdgeInsets.only(left: 100),
             child: SizedBox(
               width: 180,
               child: Text(
                 'Login',
                 style: GoogleFonts.poppins(
                   color: Colors.black,
                   fontSize: 28.5,
                   fontWeight: FontWeight.bold
                 )
               ),
             ),
           ),
         ),
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
                  isLoading=true;
                });
                try{
                  await _authProvider.signInWithEmailAndPassword(
                      emailController.text, passwordController.text).whenComplete((){
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute (builder: (BuildContext context) => const MainScreen()), (route) => false);
                  });
                }
                catch(e)
                {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Email or Password are incorrect!"),
                  ));
                }
              },
              child: const Center(child: Text('Continue')),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/reset-password');
            },
            child: const Text('forgot password?',
                style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}