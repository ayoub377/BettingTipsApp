


class Item {
  String? home;
  String? away;
  String? date;
  String? time;
  String? league;
  String? prediction;
  String? odd;
  String? iswon;
  String? probability;
  String? type;
  String? dateString;
  Item(
      {this.home,
        this.away,
        this.date,
        this.time,
        this.league,
        this.prediction,
        this.odd,
        this.type,
      this.iswon,
      this.probability,
      this.dateString});

  Item.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
    date = json['date'];
    time = json['time'];
    league = json['league'];
    prediction = json['prediction'];
    odd = json['odd'];
    type = json['type'];
    iswon = json['iswon'];
    probability = json['probability'];
    dateString = json['dateString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['home'] = home;
    data['away'] = away;
    data['date'] = date;
    data['time'] = time;
    data['league'] = league;
    data['predicton'] = prediction;
    data['odd'] = odd;
    data['type'] = type;
    data['iswon'] = iswon;
    data['probability'] = probability;
    data['dateString'] = dateString;
    return data;
  }
}