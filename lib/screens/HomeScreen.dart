import 'package:bettingtipsapp/core/notifications.dart';
import 'package:bettingtipsapp/model/itemTip.dart';
import 'package:bettingtipsapp/providers/bottomnavbarprovider.dart';
import 'package:bettingtipsapp/repository/tips_repo.dart';
import 'package:bettingtipsapp/screens/EditProfile.dart';
import 'package:bettingtipsapp/screens/TipsScreen.dart';
import 'package:bettingtipsapp/widgets/CustomTipItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/ad_helper.dart';
import 'SubscriptionScreen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final BottomNavBarProvider _bottomNavBarProvider = BottomNavBarProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
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
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();


    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd?.dispose();
        },
      ),
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
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   elevation: 0,
        //   title: Center(child: Text('Betting tips',style: TextStyle(color: Colors.black,fontSize: 20),)),
        // ),
        body: CustomScrollView(
          slivers:<Widget>[
             SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('assets/images/Betting Tips.png',fit: BoxFit.cover,),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('History of tips:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              FutureBuilder(
                  future: TipsRepo().getTips(),
                  builder: (context, AsyncSnapshot<List<ItemTip>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return CustomTipItem(date: snapshot.data![index].date.toString(), odd: snapshot.data![index].totalOdd.toString(), iswon: snapshot.data![index].iswon as bool, itemTip: snapshot.data![index], );

                          });
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
              ),
                if (_bannerAd != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,30,0,0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  )
            ])),
          ]
        ),
        bottomNavigationBar:Consumer<BottomNavBarProvider>(
            builder: (context, provider, child) {
              return bottomNavBar();
            },
          ),
      ),
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd?.dispose();

    // COMPLETE: Dispose an InterstitialAd object
    _interstitialAd?.dispose();
    super.dispose();
  }

}
