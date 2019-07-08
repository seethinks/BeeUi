import 'package:flutter/material.dart';

class XAppBar extends AppBar {
  XAppBar(
      {Key key,
      Widget title,
      Color backgroundColor,
      List<Widget> actions,
      PreferredSizeWidget bottom})
      : super(
          backgroundColor: backgroundColor,
          title: title,
          actions: actions,
          bottom: bottom,
          elevation: 0.0,
        );
}
