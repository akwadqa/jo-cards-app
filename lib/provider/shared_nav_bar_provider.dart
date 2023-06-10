import 'package:flutter/cupertino.dart';

class SharedNavBarProvider extends ChangeNotifier{
  int _bottomIndex = 0;
  int get bottomIndex => _bottomIndex;

  PageController _controller = PageController(initialPage: 0);
  PageController get controller => _controller ;
  set setController(PageController pageController){
    _controller = pageController;
    notifyListeners();
  }

  void changeBottomIndex(int value) {
    _bottomIndex = value;
    notifyListeners();
  }

  void initialController() {
    _controller.dispose();
    _controller.detach(_controller.position);
    _controller = PageController(initialPage: 0);
    notifyListeners();
  }

  void changeControllerIndex(int value) {
    _controller = PageController(initialPage: value);
    notifyListeners();
  }
}