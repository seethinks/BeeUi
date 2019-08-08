import 'package:flutter/material.dart';

class NavigatorObserverUtil extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if ((previousRoute is TransitionRoute) && previousRoute.opaque) {
      //全屏不透明，通常是一个page
      print("object11111");
    } else {
      print("object222222");
      //全屏透明，通常是一个弹窗
    }
  }
}
