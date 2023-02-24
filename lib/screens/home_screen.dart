import 'package:bettingtipsapp/model/item_tip.dart';
import 'package:bettingtipsapp/repository/tips_repo.dart';
import 'package:bettingtipsapp/screens/tips_details_screen.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart';

import '../core/ad_helper.dart';
import '../core/in_app_reviews.dart';
import '../model/item.dart';
import '../widgets/internet_not_connected.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  final TipsRepo _repo = TipsRepo();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
   InterstitialAd? _interstitialDetailsTipsAd;


  @override
  void initState() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitIdDetailsTips,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialDetailsTipsAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('InterstitialAd failed to load: $error');
          }
          _interstitialDetailsTipsAd?.dispose();
        },
      ),
    );
    showReviewPrompt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(

        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
        appBar: PreferredSize(
        preferredSize:const Size.fromHeight(100),
    child: AppBar(
    title:Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 20.0),
    child:  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
     Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: Text(
      'History of Tips',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    ),
    ),
    ],
    )),
    elevation: 0,
    backgroundColor: const Color(0xff405cbf),
      bottom: const TabBar(
        indicatorColor: Colors.deepOrange,
        labelColor: Colors.white,
        tabs: [
          Tab(text: 'Accumulator History'),
          Tab(text: 'Picks History'),
        ],
      ),
    ),
    ),
        body: Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.connected ?
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
                child: TabBarView(
                  children: [
                    FutureBuilder(
                        future: _repo.getTips(),
                        builder: (BuildContext context, AsyncSnapshot<List<ItemTip>> snapshot)
                        {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder:(context, index) {
                                  return GestureDetector(
                                      onTap: (){
                                        _interstitialDetailsTipsAd?.show();
                                        Navigator.push(context,MaterialPageRoute(builder: (_)=> TipDetails(
                                          itemTip: snapshot.data![index],
                                        )));
                                      },
                                      child: buildTipsHistory(context, snapshot.data![index]));
                                }
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty)
                          {
                            return const Text("Still empty Data");
                          }
                          else if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return const Text("load");
                        }
                    ),
                    FutureBuilder(
                        future: _repo.getGeneralTodayTips(),
                        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot)
                        {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder:(context, index) {
                                  return buildPicksHistory(context, snapshot.data![index]);
                                }
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty)
                          {
                            return const Text("Still empty Data");
                          }
                          else if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return const Text("load");
                        }
                    ),
                  ],
                ),
              ),
            ): const InternetNotAvailable()
        ),
      );
  }

  GFCard buildTipsHistory(BuildContext context, ItemTip tip) {
    return GFCard(
                          color: const Color(0XFFf4f4f4),
                          boxFit: BoxFit.cover,
                          content: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(DateTimeFormat.format(tip.date as DateTime,format: 'd / m / Y'),style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      const SizedBox(height: 10,),
                                      (tip.type == "football")? const Icon(Icons.sports_soccer_outlined): const Icon(Icons.sports_basketball)
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Total odd: ",style:TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,)),
                                          Text("${tip.totalOdd}"),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                      ),
                                      Row(
                                        children: [
                                          const Text("Status: ",style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          ),),
                                          (tip.iswon == "") ? Container(
                                              color: Colors.orangeAccent,
                                              child: const Text("In Play...",style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500
                                              ),)): (tip.iswon == "true") ?
                                          const Text("WON",style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white,
                                            backgroundColor: Colors.green
                                          ),) : const Text("LOST",style: TextStyle(
                                              backgroundColor: Colors.red,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ));
  }
  GFCard buildPicksHistory(BuildContext context, Item pick) {
    return GFCard(
        color: const Color(0XFFf4f4f4),
        boxFit: BoxFit.cover,
        content: Column(
          children: [
            Text(pick.dateString!,style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text('${pick.home} vs ${pick.away}',style: TextStyle(
                fontWeight: FontWeight.w700
              ),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text("odd: ${pick.odd}",style:TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,)),
                 Text("${pick.prediction}",style:TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.w500,)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Status: ${pick.iswon == "" ? "Inplay" : pick.iswon == "true" ? "WON" : "LOST"}",style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                     color: (pick.iswon == "") ? Colors.orange : (pick.iswon == "true") ? Colors.green : Colors.red
                   ),),
                  Text("Probability: ${pick.probability}",style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16
                  ),)
                ],
              ),
            ),
          ],
        ));
  }

}


