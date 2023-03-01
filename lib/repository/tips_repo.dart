import 'package:bettingtipsapp/model/item_tip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/bet.dart';
import '../model/item.dart';

class TipsRepo {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DateTime date = DateTime.now();
  String todayTips = DateTimeFormat.format(DateTime.now(),format: 'd m Y');
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addBet(Bet bet) async {
    await _db.collection('bets').add(bet.toJson());
  }

  Future<List<Bet>> getBets() async{
    QuerySnapshot snapshot = await _db.collection('bets').get();
    return snapshot.docs.map((doc) => Bet.fromJson(doc.data() as Map<String, dynamic> )).toList();
  }

  Future<List<Bet>> getMonthBetData(int month) async {
      QuerySnapshot snapshot = await _db
          .collection("bets")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year, month, 1)))
          .where("date", isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, month + 1, 1))).where("uid", isEqualTo: _currentUserId)
          .get();
    return snapshot.docs.map((doc) => Bet.fromJson(doc.data() as Map<String, dynamic> )).toList();
  }

  Future<double> getMonthProfitLoss(int month) async {
    List<Bet> bets;
    double profitLossCalc=0;
    QuerySnapshot snapshot = await _db
        .collection("bets")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year, month, 1)))
        .where("date", isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, month + 1, 1))).where("uid", isEqualTo: _currentUserId)
        .get();
     bets = snapshot.docs.map((doc) => Bet.fromJson(doc.data() as Map<String, dynamic> )).toList();
    bets.forEach((bet){
      if (bet.payout!.isNotEmpty) {
         profitLossCalc += double.parse(bet.payout!) - double.parse(bet.amount!);
      }
    });
    return profitLossCalc;
  }

  Future<List<ItemTip>> getTips() async {
    CollectionReference tips = _db.collection('item_Tip');
    QuerySnapshot querySnapshot = await tips.where("date", isLessThan:date).orderBy("date",descending: true).get();
    return querySnapshot.docs.map((doc) => ItemTip.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Item>> getPicks() async {
    CollectionReference picks = _db.collection('general_picks');
    QuerySnapshot querySnapshot = await picks.where("date", isLessThan:date).orderBy("date",descending: true).get();
    return querySnapshot.docs.map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<ItemTip>> getFootballTodayTips() async {
    CollectionReference tips = _db.collection('item_Tip');
    QuerySnapshot querySnapshot = await tips.where("dateString", isEqualTo: todayTips).where("type", isEqualTo:"football").get();
    return querySnapshot.docs.map((doc) => ItemTip.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Item>> getGeneralTodayTips() async {
    CollectionReference tips = _db.collection('general_picks');
    QuerySnapshot querySnapshot = await tips.where("dateString", isEqualTo:todayTips).get();
    return querySnapshot.docs.map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

}


