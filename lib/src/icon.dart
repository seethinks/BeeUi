import 'package:flutter/widgets.dart';

class BeeIcon {
  static const IconData rightArrow = const _MyIconData(0xe600);
  static const IconData leftArrow = const _MyIconData(0xe60a);
  static const IconData success = const _MyIconData(0xe614);
  static const IconData fail = const _MyIconData(0xe6f1);
  static const IconData inputClean = const _MyIconData(0xe63e);
  static const IconData noData = const _MyIconData(0xe61f);
  static const IconData netError = const _MyIconData(0xe616);
  static const IconData eyeOpen = const _MyIconData(0xe858);
  static const IconData eyeClose = const _MyIconData(0xe601);
}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint)
      : super(codePoint,
            fontFamily: 'iconfont',
            matchTextDirection: true,
            fontPackage: "beeui");
}
