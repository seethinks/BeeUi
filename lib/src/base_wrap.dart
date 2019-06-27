import 'package:beeui/config.dart';
import 'package:flutter/material.dart';

class BaseWrap extends StatelessWidget {
  final Widget body;
  final List<Widget> actions;
  final Widget bottomNavigationBar;
  final AppBar appbar;

  BaseWrap(
      {Key key, this.appbar, this.bottomNavigationBar, this.body, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget title = appbar.title;

    if (title != null) {
      title = DefaultTextStyle(
        style: TextStyle(fontSize: 14, color: Colors.black),
        child: Semantics(
          child: title,
          header: true,
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            //自定义导航栏高度
            preferredSize: Size.fromHeight(DefaultConfig.appBarHeight),
            child: AppBar(
                leading: appbar.leading != null ? appbar.leading : null,
                elevation: appbar.elevation ?? 0,
                title: title,
                centerTitle: true,
                brightness: appbar.brightness ?? Brightness.dark,
                backgroundColor: appbar.backgroundColor ?? Colors.white,
                actions: actions)),
        bottomNavigationBar: bottomNavigationBar,
        body: body);
  }
}
