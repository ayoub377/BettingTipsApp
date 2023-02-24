
import 'package:flutter/material.dart';

Widget  itemTipCard(BuildContext context,data){
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data?.date ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            (data.type == 'football')?
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: CircleAvatar(
                    child: Image.asset('assets/icons/ballon-de-football.png')
                  ),
                ):
            CircleAvatar(
                child: Image.asset('assets/icons/basketball.png')
            )
          ],
        ),
        Row(
          children: [
            Text(data.time ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          ],
        ),
        Row(
          children: [
            Text("${data.home ?? ''} vs ${data.away ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(data.prediction ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ],
          ),
        ),
        Row(
          children: [
            Text("odd: ${data.odd?.toString() ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          ],
        ),
      ],
    ),
  );

}
