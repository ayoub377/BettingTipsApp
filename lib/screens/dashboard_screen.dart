import 'package:bettingtipsapp/repository/tips_repo.dart';
import 'package:bettingtipsapp/widgets/internet_not_connected.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/ad_helper.dart';
import '../core/config.dart';
import '../model/bet.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboradState();
}

class _DashboradState extends State<Dashboard> {

   final TipsRepo _tipsRepo = TipsRepo();
   List<String> list = <String>['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
   String selectedMonth = DateFormat("MMMM").format(DateTime.now());
   int selectedMonthNumber=DateTime.now().month;
   BannerAd? _bannerAd;


   @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
         backgroundColor: Colors.white,
         appBar: PreferredSize(
           preferredSize: const Size.fromHeight(100),
           child: AppBar(
             title:Padding(
                 padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                 child:  Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: const <Widget>[
                      Padding(
                       padding: EdgeInsets.only(left: 15.0),
                       child: Text('Dashboard', style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 20.0,
                           fontFamily: 'sans-serif-light',
                           color: Colors.white)),
                     ),
                   ],
                 )),
             elevation: 0,
             backgroundColor: const Color(0xff405cbf),
           ),
         ),
         body: Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.connected ? Column(
           mainAxisSize: MainAxisSize.max,
           children: [
           DropdownButton<String>(
           value: selectedMonth,
           icon: const Icon(Icons.arrow_downward),
           elevation: 16,
           style: const TextStyle(color: Colors.deepPurple),
           underline: Container(
             height: 2,
             color: Colors.deepPurpleAccent,
           ),
           onChanged: (String? value) async {
             // This is called when the user selects an item.
               switch(value){
                 case 'January':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 1;
                   });
                   break;
                 case 'February':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 2;

                   });
                   break;
                 case 'March':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 3;
                   });
                   break;
                 case 'April':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 4;

                   });
                   break;
                 case 'May':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 5;

                   });
                   break;
                 case 'June':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 6;

                   });
                   break;
                 case 'July':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 7;
                   });
                   break;
                 case 'August':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 8;

                   });
                   break;
                 case 'September':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 9;

                   });
                   break;
                 case 'October':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 10;

                   });
                   break;
                 case 'December':
                   setState(() {
                     selectedMonth = value!;
                     selectedMonthNumber = 11;

                   });
                   break;
               }
           },
           items: list.map<DropdownMenuItem<String>>((String value) {
             return DropdownMenuItem<String>(
               value: value,
               child: Text(value),
             );
           }).toList(),
         ),
             FutureBuilder(
                 future: _tipsRepo.getMonthBetData(selectedMonthNumber),
                 builder: (context,AsyncSnapshot<List<Bet>> snapshot) {
                   double profitLoss = 0;
                   if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                     snapshot.data!.forEach((bet) {
                         if (bet.payout!.isNotEmpty) {
                           profitLoss += double.parse(bet.payout!) - double.parse(bet.amount!) ;
                         }
                     });
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 2,
                            child: LineChart(
                                LineChartData(
                                  titlesData: FlTitlesData(
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                                      showTitles: true,
                                    )),
                                  ),
                                  maxX: Config.monthDays[selectedMonthNumber.toString()],
                                  minX: 0,
                                  minY: -10000,
                                  gridData: FlGridData(
                                    show: false,
                                  ),
                                  lineTouchData: LineTouchData(
                                    touchTooltipData: LineTouchTooltipData(
                                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                        return touchedBarSpots.map((barSpot) {
                                          final flSpot = barSpot;
                                          if (flSpot.x != 0 && flSpot.y != 0) {
                                            return LineTooltipItem(
                                              "Day:${flSpot.x.toInt()}\n Amount:${flSpot.y}",
                                              TextStyle(color: Colors.yellow),
                                            );
                                          }
                                          return null;
                                        }).toList();
                                      },
                                    ),
                                    handleBuiltInTouches: true,
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: const Border(
                                      bottom: BorderSide(
                                        color: Colors.black
                                      ),
                                        left: BorderSide(
                                            color: Colors.black
                                        )
                                    )
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: snapshot.data!.map((bet) => FlSpot(bet.date!.toDate().day.toDouble(), double.parse(bet.payout!))).toList(),
                                      isCurved: true,
                                      curveSmoothness: 0,
                                      color:
                                        Colors.red ,
                                      barWidth: 2,
                                    ),
                                  ],
                                ),
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               const Text(
                                  "profit/Loss:",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  profitLoss.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color : profitLoss < 0 ? Colors.red : Colors.green
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                   }
                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
                     return Center(child: Text("No data!", style: TextStyle(
                         fontSize: 22,
                         color: Colors.grey.shade500
                     )));
                   }
                   else {
                     return const Center(
                       child: CircularProgressIndicator(),
                     );
                   }
                 }),
             Expanded(
               child: Align(
                 alignment: Alignment.bottomCenter,
                 child: _bannerAd != null ?  Container(
                   width: MediaQuery.of(context).size.width,
                   color: Colors.white,
                   child:
                   SizedBox(
                     width: _bannerAd!.size.width.toDouble(),
                     height: _bannerAd!.size.height.toDouble(),
                     child: AdWidget(ad: _bannerAd!),
                   ),
                 ) : Container(),
               ),
             )
           ],
         ) : const InternetNotAvailable(),
       );
  }
}


