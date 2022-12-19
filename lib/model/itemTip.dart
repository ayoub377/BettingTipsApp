import 'package:bettingtipsapp/model/item.dart';




class ItemTip {
  List<Item>? item;
  String? date;
  bool? iswon;
  String? totalOdd;
  String? type;

  ItemTip({this.item, this.date, this.iswon, this.totalOdd, this.type});

  ItemTip.fromJson(Map<String, dynamic> json) {
    if (json['tips'] != null) {
      item = <Item>[];
      json['tips'].forEach((v) {
        item!.add(new Item.fromJson(v));
      });
    }
    date = json['date'];
    iswon = json['iswon'];
    totalOdd = json['total_odd'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['iswon'] = this.iswon;
    data['total_odd'] = this.totalOdd;
    return data;
  }


}
