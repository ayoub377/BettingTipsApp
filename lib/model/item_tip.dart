import 'package:bettingtipsapp/model/item.dart';


class ItemTip {
  List<Item>? item;
  DateTime? date;
  String? iswon;
  String? totalOdd;
  String? type;
  String? dateString;

  ItemTip({this.item, this.date, this.iswon, this.totalOdd, this.type, this.dateString});

  ItemTip.fromJson(Map<String, dynamic> json) {
    if (json['tips'] != null) {
      item = <Item>[];
      json['tips'].forEach((v) {
        item!.add(Item.fromJson(v));
      });
    }
    date = json['date'].toDate();
    iswon = json['iswon'];
    totalOdd = json['total_odd'];
    type = json['type'];
    dateString = json['dateString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (item != null) {
      data['item'] = item!.map((v) => v.toJson()).toList();
    }
    data['date'] = date;
    data['iswon'] = iswon;
    data['total_odd'] = totalOdd;
    return data;
  }

}
