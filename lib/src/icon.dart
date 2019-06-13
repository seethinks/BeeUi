import 'package:flutter/widgets.dart';

class BeeIcon {
  static const IconData rightArrow = const _MyIconData(0xe600);
  static const IconData leftArrow = const _MyIconData(0xe60a);
}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint)
      : super(codePoint,
            fontFamily: 'iconfont',
            matchTextDirection: true,
            fontPackage: "beeui");
}
