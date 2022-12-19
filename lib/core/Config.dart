

class Config{

  static final String appId = "Cp7xtuLUXiSwZnBNjiQxAcKH8ieWuRtiLDBt1ZOc";
  static final String clientKey = "K4IxquBCqxmQ9KEHKksCZhLQfNc0C2sTF5QJZwHa";
  static final String serverUrl = "https://parseapi.back4app.com/";

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

  static final String one_month = "bettingapp.onemonth";
  static final String six_month = "bettingapp.sixmonths";
  static final String one_year = "bettingapp.oneyear";

}