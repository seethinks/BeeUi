import 'package:flutter/material.dart';
import 'package:beeui/src/icon.dart';

class BaseWrap extends StatelessWidget {
  final Widget title;
  final int elevation;
  final Widget leading;
  final Widget body;
  final List<Widget> actions;

  BaseWrap(
      {Key key,
      this.title,
      this.leading,
      this.elevation = 0,
      this.body,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: leading != null
                ? leading
                : IconButton(
                    icon: Icon(
                      BeeIcon.leftArrow,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () => {Navigator.pop(context)}),
            elevation: 0,
            title: title,
            centerTitle: true,
            actions: actions),
        // body: SingleChildScrollView(
        //   child: body,
        // )
        body: body);
  }
}
