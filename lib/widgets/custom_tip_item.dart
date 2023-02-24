import 'package:bettingtipsapp/model/item_tip.dart';
import 'package:bettingtipsapp/screens/tips_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class CustomTipItem extends StatelessWidget {
  final String date;
  final String odd;
  final bool iswon;
  final ItemTip itemTip;
   const CustomTipItem({Key? key,required this.date,required this.odd,required this.iswon, required this.itemTip}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: const Color.fromARGB(100, 152, 144, 208),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Container(
          width: 30,
          height: 30,
          decoration: iswon ? BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/green_check_img.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ) : BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/error_img.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Text(date.toString().substring(0,10)),
        trailing: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text("odd:${odd.toString().substring(0,3)}",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>TipDetails(itemTip: itemTip,)));
        },
      ),
    );
  }
}
