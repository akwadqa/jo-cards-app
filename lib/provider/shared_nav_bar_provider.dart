import 'package:flutter/cupertino.dart';

class SharedNavBarProvider extends ChangeNotifier{
  int _bottomIndex = 0;
  int get bottomIndex => _bottomIndex;

  PageController _controller = PageController(initialPage: 0);
  PageController get controller => _controller ;

  void changeBottomIndex(int value) {
    _bottomIndex = value;
    notifyListeners();
  }

  void changeControllerIndex(int value) {
    _controller = PageController(initialPage: value);
    notifyListeners();
  }
}