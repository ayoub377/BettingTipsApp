import 'package:bettingtipsapp/auth/auth_screen.dart';
import 'package:bettingtipsapp/providers/auth_provider.dart';
import 'package:bettingtipsapp/screens/edit_profile_screen.dart';
import 'package:bettingtipsapp/screens/tips_list_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/ad_helper.dart';
import '../core/in_app_reviews.dart';
import 'home_screen.dart';


class MainScreen extends StatefulWidget {
  final int? index;
  const MainScreen({Key? key, this.index}) : super(key: key);
  static const String routeName = 'home-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialListTipsAd;
  int _selectedIndex = 0;
  final AuthProvider _authProvider = AuthProvider();
  static final List<Widget> _widgetOptions =  <Widget>[
    const HomeScreen(),
    const TipsScreen(),
    const EditProfileScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      _interstitialListTipsAd?.show();
    }
  }

  @override
  void initState() {
    if (widget.index != null) {
      _selectedIndex = widget.index!;
    }
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitListTips,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialListTipsAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('InterstitialAd failed to load: $error');
          }
          _interstitialListTipsAd?.dispose();
        },
      ),
    );
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
    storeInstallationDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _authProvider.auth.currentUser != null
            ? _widgetOptions.elementAt(_selectedIndex)
            : const AuthScreen(),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
              if(_bannerAd != null)
                    Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
        ),
        ),
          Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300))),
              child: _authProvider.auth.currentUser != null
                  ? BottomNavigationBar(
                      items: [
                          BottomNavigationBarItem(
                            icon: Icon(_selectedIndex == 0
                                ? Icons.home
                                : Icons.home_outlined),
                            label: 'home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(_selectedIndex == 1
                                ? Icons.format_list_bulleted_outlined
                                : Icons.format_list_bulleted),
                            label: 'tips',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.account_circle,
                              size: 30,
                            ),
                            label: 'profile',
                          ),
                        ],
                      type: BottomNavigationBarType.fixed,
                      elevation: 4,
                      currentIndex: _selectedIndex,
                      selectedLabelStyle: const TextStyle(
                        color: Color(0xff405cbf),
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        color: Colors.white10,
                        fontSize: 14,
                      ),
                      unselectedItemColor: Colors.grey,
                      onTap: _onItemTapped)
                  : Container()),
        ],
      ),
    );
  }
}
