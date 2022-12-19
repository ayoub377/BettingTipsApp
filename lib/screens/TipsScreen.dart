import 'package:bettingtipsapp/providers/bottomnavbarprovider.dart';
import 'package:bettingtipsapp/repository/tips_repo.dart';
import 'package:bettingtipsapp/screens/HomeScreen.dart';
import 'package:bettingtipsapp/screens/EditProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/itemTip.dart';
import '../widgets/ItemTip.dart';
import 'SubscriptionScreen.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);
  static const routeName = '/tips';

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  BottomNavBarProvider _bottomNavBarProvider = BottomNavBarProvider();
  TipsRepo tipsRepo = TipsRepo();
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
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
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: const Text('Tips', style: TextStyle(color: Colors.black),),
            bottom: const TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(text: 'Football',icon: Icon(Icons.sports_soccer_rounded),),
                Tab(text: 'Basketball', icon: Icon(Icons.sports_basketball_sharp),),
              ],
            ),
          ),
          body: TabBarView(
                  children:[
                 FutureBuilder(
                future: tipsRepo.getFootballTodayTips(),
                builder: (context,AsyncSnapshot<List<ItemTip>> snapshot) {
                  if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data![0].item!.length,
                            itemBuilder:(context, index) {
                            return ItemTipCard(context,snapshot.data![0].item![index]);
                            }
                        );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
        ),
                    FutureBuilder(
                      future: tipsRepo.getBasketTodayTips(),
                      builder: (context,AsyncSnapshot<List<ItemTip>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data![0].item!.length,
                              itemBuilder:(context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(snapshot.data?[index].item?[index].date ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(snapshot.data![index].item![index].time ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("${snapshot.data?[index].item?[index].home ?? ''} vs ${snapshot.data?[index].item?[index].away ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(snapshot.data?[index].item?[index].prediction ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("odd: ${snapshot.data?[index].item?[index].odd?.toString() ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ]
                ),
          bottomNavigationBar: bottomNavBar(),
          ),
      ),
      );
  }

}

