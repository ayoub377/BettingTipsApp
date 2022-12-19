import 'package:flutter/cupertino.dart';




class BottomNavBarProvider with ChangeNotifier {
  static int _currentIndex = 0;
  double get elevation => _getElevation();
  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  double _getElevation() {
    if (currentIndex == 0) {
      return 0;
    } else {
      return 8;
    }
  }

}