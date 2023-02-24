

import 'package:cloud_firestore/cloud_firestore.dart';

class Bet {
  String? uid;
  String? amount;
  String? payout;
  Timestamp? date;
  bool? outcome;

  Bet({ this.uid, this.amount, this.date, this.outcome,this.payout});

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      uid: json['uid'],
      amount: json['amount'],
      payout: json['payout'],
      date: json['date'],
      outcome: json['outcome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'amount': amount,
      'payout': payout,
      'date': date,
      'outcome': outcome,
    };
  }
}

