import 'package:bettingtipsapp/widgets/internet_not_connected.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            title: Text("Back",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            elevation: 0,
            backgroundColor: const Color(0xff405cbf),
          ),
        ),
        backgroundColor: Colors.white,
        body: Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.connected ? SingleChildScrollView(
            child: Column(
                children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: LoginForm(),
                    ),
                  ])))
        ])): const InternetNotAvailable()
    );
  }
}
