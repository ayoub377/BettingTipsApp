

class Config{

  static const String appId = "Cp7xtuLUXiSwZnBNjiQxAcKH8ieWuRtiLDBt1ZOc";
  static const String clientKey = "K4IxquBCqxmQ9KEHKksCZhLQfNc0C2sTF5QJZwHa";
  static const String serverUrl = "https://parseapi.back4app.com/";

  //InApp Purchase

  static final List<Map<String,String>> subscriptions=[
    {
      "type of subscription":"1 Month",
      "price of subscription":"9.99\$",

    },
    {
      "type of subscription":"6 Months",
      "price of subscription":"19.99\$",

    },
    {
      "type of subscription":"1 year",
      "price of subscription":"99.99\$",

    }
  ];

  // Inapp Purchase Google play Ids

  static const String oneMonth = "bettingapp.onemonth";
  static const String sixMonth = "bettingapp.sixmonths";
  static const String oneYear = "bettingapp.oneyear";

  // Constants
  static const Map<String, double> monthDays = {
    '1': 31,
    '2': 28,
    '3': 31,
    '4': 30,
    '5': 31,
    '6': 30,
    '7': 31,
    '8': 31,
    '9': 30,
    '10': 31,
    '11': 30,
    '12': 31,
  };
}