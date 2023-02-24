import 'package:bettingtipsapp/model/item.dart';
import 'package:bettingtipsapp/repository/tips_repo.dart';
import 'package:bettingtipsapp/screens/wrapper.dart';
import 'package:bettingtipsapp/widgets/internet_not_connected.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../core/themes.dart';
import '../model/bet.dart';
import '../model/item_tip.dart';


class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);
  static const routeName = '/tips';

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {

  TipsRepo tipsRepo = TipsRepo();
  bool? isBet=false;
  TextEditingController amount = TextEditingController();
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
  }

  Widget betTrackerField({Timestamp? date, String? totalOdd, String? uid}){
    return Column(
      children: [
        CheckboxListTile(
            title: Text("Are you betting on this Ticket?"),
            value: isBet, onChanged: (value){
          setState(() {
            isBet = value;
          });
        }),
        if(isBet == true)
        Padding(
          padding: const EdgeInsets.only(left: 40.0,right: 40),
          child: TextFormField(
            controller: amount,
            decoration: const InputDecoration(
              label: Center(
                child: Text("Amount to Bet ",style: TextStyle(
                  fontSize: 18,fontWeight: FontWeight.bold
                ),),
              )
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isBet == true ? () async{
            EasyLoading.show();
           double payout = double.parse(totalOdd!) * double.parse(amount.text);
           String payoutVal = payout.toString();
           Bet bet = Bet(uid: uid, amount: amount.text, date: date,payout: payoutVal);
           await tipsRepo.addBet(bet);
           await EasyLoading.showSuccess('Bet Tracked!');
           amount.clear();
           if (mounted) {
             Navigator.of(context).push(MaterialPageRoute (
             builder: (BuildContext context) => const MainScreen(),
           ),);
           }
        } : null , child: Text("Track this bet!",style: TextStyle(
    fontSize: 18,fontWeight: FontWeight.bold
    ),),style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.themeColor)
        ),)
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: AppTheme.themeColor,
              elevation: 0,
              title: const Center(child: const Text('Today Tips', style: TextStyle(color: Colors.white),)),
              bottom: const TabBar(
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.white,
                tabs: [
                  Tab(text: 'Accumulator',icon: Icon(Icons.sports_soccer_rounded,color: Colors.white,),),
                  Tab(text: 'General picks', icon: Icon(Icons.tips_and_updates_rounded,color: Colors.white),),
                ],
              ),
            ),
          ),
          body: Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.connected ? Container(
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
                    physics: const NeverScrollableScrollPhysics(),
                      children:[
                    FutureBuilder(
                      future: tipsRepo.getFootballTodayTips(),
                      builder: (context,AsyncSnapshot<List<ItemTip>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data![0].item!.length,
                                  itemBuilder:(context, index) {
                                  return  snapshot.data![0].item![index].home!.isEmpty ? Container():
                                    buildTips(snapshot.data![0].item![index], index);
                                  }
                              ),
                              betTrackerField(date: Timestamp.fromDate(snapshot.data![0].date!),totalOdd:snapshot.data![0].totalOdd,uid:uid)
                            ],
                          );
                        }
                        if(!snapshot.hasData || snapshot.data!.isEmpty){
                          return Center(child: Text("No data!",style:TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade500
                          )));
                        }
                        else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    FutureBuilder(
                      future: tipsRepo.getPicks(),
                      builder: (context,AsyncSnapshot<List<Item>> snapshot)
                      {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder:(context, index) {
                                return buildTips(snapshot.data![index], index);
                              }
                          );
                        }
                        if(!snapshot.hasData || snapshot.data!.isEmpty){
                          return Center(child: Text("No data!",style:TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade500
                          )));
                        }
                        else if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return const Text("load");
                      },
                    ),
                  ]),
                ),
              ) : const InternetNotAvailable(),
        ),
      );
  }

  Container buildTips(Item snapshot, int index) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0XFFf4f4f4),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.date ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.time ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: const Color(0xFF8ecce6)),
                shape: BoxShape.rectangle
            ),
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Row(
                    children: [
                      Text("${snapshot.home ?? ''} vs ${snapshot.away ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Row(
                    children: [
                      Text("odd: ${snapshot.odd?.toString() ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      const SizedBox(width: 20,),
                      Text("prediction: ${snapshot.prediction ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Row(
                    children: [
                      if(snapshot.probability!.isNotEmpty)
                         Text("probability: ${snapshot.probability?.toString() ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      const SizedBox(width: 20,),
                      (snapshot.iswon == "true") ?
                        Text("Won", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.green),):
                        Text("Lost", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red),)

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

