import 'package:flutter/material.dart';

class BaseWrap2 extends StatefulWidget {
  final Widget body;
  final List<Widget> actions;
  final Widget bottomNavigationBar;
  final AppBar appbar;

  BaseWrap2(
      {Key key, this.appbar, this.bottomNavigationBar, this.body, this.actions})
      : super(key: key);
  @override
  _BaseWrapState createState() => _BaseWrapState();
}

class _BaseWrapState extends State<BaseWrap2> {
  bool lastStatus = true;
  ScrollController _scrollController;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (80 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget title = widget.appbar.title;

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
        body: CustomScrollView(slivers: <Widget>[
      // SliverAppBar(
      //     expandedHeight: 50.0,
      //     floating: false,
      //     pinned: true,
      //     backgroundColor: Colors.white,
      //     forceElevated: false, // 是否显示层次感
      //     flexibleSpace: FlexibleSpaceBar(
      //       title: Text('Expanded Title'),
      //       collapseMode: CollapseMode.parallax,
      //       // background: Image.asset('images/timg.jpg', fit: BoxFit.cover),
      //     )),
      SliverFillRemaining(
        child: widget.body,
      ),
    ]));
  }
}
