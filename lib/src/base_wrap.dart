import 'package:flutter/material.dart';
import 'package:beeui/src/icon.dart';

class BaseWrap extends StatelessWidget {
  final Widget title;
  final int elevation;
  final Widget leading;
  final Widget body;
  final List<Widget> actions;
  final Widget bottomNavigationBar;

  BaseWrap(
      {Key key,
      this.title,
      this.leading,
      this.elevation = 0,
      this.bottomNavigationBar,
      this.body,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: leading != null ? leading : null,
            // IconButton(
            //     icon: Icon(
            //       BeeIcon.leftArrow,
            //       color: Colors.white,
            //       size: 22,
            //     ),
            //     onPressed: () => {Navigator.pop(context)}),
            elevation: 0,
            title: title,
            centerTitle: true,
            actions: actions),
        // body: SingleChildScrollView(
        //   child: body,
        // )
        bottomNavigationBar: bottomNavigationBar,
        body: body);
  }
}
