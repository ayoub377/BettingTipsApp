import 'package:bettingtipsapp/model/itemTip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/ad_helper.dart';

class TipDetails extends StatefulWidget {
  final ItemTip? itemTip;
  TipDetails({Key? key,this.itemTip}) : super(key: key);
  static const routeName = '/tipDetails';

  @override
  State<TipDetails> createState() => _TipDetailsState();
}



class _TipDetailsState extends State<TipDetails> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Container(
             child:ListView.builder(
                 itemCount: widget.itemTip?.item?.length,
                 itemBuilder: (context, index)
                 {
                   return Card(
                     shape: RoundedRectangleBorder(
                       side: BorderSide(color: Colors.black, width: 1),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.itemTip?.item?[index].date.toString() ?? 'default'),
                            Text(widget.itemTip?.item?[index].time.toString() ?? 'default'),
                          ],
                        ),
                        subtitle: Column(
                          children:[
                            Row(
                              children: [
                                Text(widget.itemTip?.item?[index].home.toString() ?? 'default',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                                Text("  Vs  "),
                                Text(widget.itemTip?.item?[index].away.toString() ?? 'default',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.itemTip?.item?[index].league.toString() ?? 'default'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                Text('prediction: ${widget.itemTip?.item?[index].prediction.toString() ?? 'default'}'),
                                Text(" odd:${widget.itemTip?.item?[index].odd.toString() ?? 'default'}"),
                              ],

                            )
                          ]
                        ),
                        ),
                   );
                 }
             )
        ),
        ),
    );

  }
}
