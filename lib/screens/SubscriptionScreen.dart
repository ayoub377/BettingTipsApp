
import 'package:bettingtipsapp/widgets/SubscriptionWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/Config.dart';
import '../providers/bottomnavbarprovider.dart';
import 'EditProfile.dart';
import 'HomeScreen.dart';
import 'TipsScreen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);
  static const routeName = '/subscription';
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  BottomNavBarProvider _bottomNavBarProvider = BottomNavBarProvider();

  BottomNavigationBar bottomNavBar() {
    Color bgColor = Colors.white;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Image.asset('assets/icons/accueil.png', width: 30, height: 30,),
          label: 'home',
        ),
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Icon(Icons.workspace_premium_rounded,),
          label: 'subscription',
        ),
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Image.asset('assets/icons/list.png', width: 30, height: 30,),
          label: 'tips',
        ),
        BottomNavigationBarItem(
          backgroundColor: bgColor,
          icon: Image.asset('assets/icons/setting.png', width: 30, height: 30,),
          label: 'profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      elevation: _bottomNavBarProvider.elevation,
      currentIndex: _bottomNavBarProvider.currentIndex,
      selectedLabelStyle: TextStyle(
          color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
          color: Colors.white10, fontSize: 12, fontWeight: FontWeight.bold),
      onTap: (index) {
        _bottomNavBarProvider.changeIndex(index);
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomeScreen()), (route) => false);
            break;
          case 1:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>SubscriptionScreen()), (route) => false);
            break;
          case 2:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>TipsScreen()), (route) => false);
            break;
          case 3:
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>EditProfileScreen()), (route) => false);
            break;
        }
      },
    );
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
        backgroundColor: Colors.transparent,
      //       appBar: AppBar(
      //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //       elevation: 0,
      // ),
         body: Padding(
           padding: const EdgeInsets.fromLTRB(0,30,0,0),
           child: SizedBox(
             width: MediaQuery.of(context).size.width,
             height: 400,
             child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: Config.subscriptions.length,
                 itemBuilder: (context,index){
                   return Container(
                       padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                       width: 300,
                       height: 200,
                       child: SubscriptionWidget(context, Config.subscriptions[index], () => null));
                 }
             ),
           ),
         ),
          bottomNavigationBar: bottomNavBar() ,
      ),
    );
  }
}
