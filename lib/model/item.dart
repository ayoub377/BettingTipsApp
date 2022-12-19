


class Item {
  String? home;
  String? away;
  String? date;
  String? time;
  String? league;
  String? prediction;
  String? odd;
  String? type;
  Item(
      {this.home,
        this.away,
        this.date,
        this.time,
        this.league,
        this.prediction,
        this.odd,
        this.type});

  Item.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
    date = json['date'];
    time = json['time'];
    league = json['league'];
    prediction = json['prediction'];
    odd = json['odd'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
    data['date'] = this.date;
    data['time'] = this.time;
    data['league'] = this.league;
    data['predicton'] = this.prediction;
    data['odd'] = this.odd;
    data['type'] = this.type;
    return data;
  }
}