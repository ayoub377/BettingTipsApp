import 'package:bettingtipsapp/model/itemTip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DateTime datime = DateTime.now();
  String date = DateTime.now().toString().substring(0, 10);

  Future<List<ItemTip>> getTips() async {
    CollectionReference tips = await _db.collection('item_Tip');
    QuerySnapshot querySnapshot = await tips.where("date", isLessThan:date).orderBy("date",descending: true).get();
    return querySnapshot.docs.map((doc) => ItemTip.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<ItemTip>> getFootballTodayTips() async {
    CollectionReference tips = await _db.collection('item_Tip');
    QuerySnapshot querySnapshot = await tips.where("date", isEqualTo:date).where("type", isEqualTo: "football").get();
    return querySnapshot.docs.map((doc) => ItemTip.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<ItemTip>> getBasketTodayTips() async {
    CollectionReference tips = await _db.collection('item_Tip');
    QuerySnapshot querySnapshot = await tips.where("date", isEqualTo:date).where("type", isEqualTo: "basketball").get();
    return querySnapshot.docs.map((doc) => ItemTip.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }


  }


