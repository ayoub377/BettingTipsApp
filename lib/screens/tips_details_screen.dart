import 'package:bettingtipsapp/model/item_tip.dart';
import 'package:bettingtipsapp/widgets/internet_not_connected.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';


class TipDetails extends StatefulWidget {
  final ItemTip? itemTip;
  const TipDetails({Key? key,this.itemTip}) : super(key: key);
  static const routeName = '/tipDetails';

  @override
  State<TipDetails> createState() => _TipDetailsState();
}

class _TipDetailsState extends State<TipDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Text("Details Tip of: ${DateTimeFormat.format(widget.itemTip!.date!, format: 'D M, Y')}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          elevation: 0,
          backgroundColor: const Color(0xff405cbf),
        ),
      ),
      backgroundColor: const Color(0xff405cbf),
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
          child: ListView.builder(
              itemCount: widget.itemTip?.item?.length,
              itemBuilder: (context, index)
              {
                return widget.itemTip?.item![index].home == ""? Container():
                buildTips(widget.itemTip!, index);
              }
          ),
        ),
      ) : const InternetNotAvailable(),
    );
  }

  Container buildTips(ItemTip snapshot, int index) {
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
              Text(snapshot.item?[index].date ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.item![index].time ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                      Text("${snapshot.item?[index].home ?? ''} vs ${snapshot.item?[index].away ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Row(
                    children: [
                      Text("odd: ${snapshot.item?[index].odd?.toString() ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      const SizedBox(width: 20,),
                      Text("prediction: ${snapshot.item?[index].prediction ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
