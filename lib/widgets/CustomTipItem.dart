import 'package:bettingtipsapp/model/itemTip.dart';
import 'package:bettingtipsapp/screens/TipDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/ad_helper.dart';

class CustomTipItem extends StatefulWidget {
  final String date;
  final String odd;
  final bool iswon;
  final ItemTip itemTip;
   CustomTipItem({Key? key,required this.date,required this.odd,required this.iswon, required this.itemTip}) : super(key: key);

  @override
  State<CustomTipItem> createState() => _CustomTipItemState();
}



class _CustomTipItemState extends State<CustomTipItem> {
 InterstitialAd? _interstitialAd;
 bool _isInterstitialAdLoaded = false;
  @override
  void initState(){
    super.initState();
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Ad loaded.');
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdLoaded = false;
          _interstitialAd?.dispose();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Container(
          width: 30,
          height: 30,
          decoration: widget.iswon ? BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/green_check_img.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ) : BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/error_img.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Text(widget.date.toString().substring(0,10)),
        trailing: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text("odd:"+widget.odd.toString().substring(0,3),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
        ),
        onTap: (){
          if(_isInterstitialAdLoaded){
            _interstitialAd?.show();
          }
          Navigator.push(context, MaterialPageRoute(builder: (context)=>TipDetails(itemTip: widget.itemTip,)));
        },
      ),
    );
  }
}
