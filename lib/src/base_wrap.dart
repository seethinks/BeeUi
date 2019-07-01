import 'package:flutter/material.dart';

import '../config.dart';

class BaseWrap extends StatefulWidget {
  final Widget body;
  final Widget bottomNavigationBar;
  final AppBar appbar;
  final EdgeInsets padding;
  final bool defaultShowTitle;

  BaseWrap(
      {Key key,
      this.appbar,
      this.bottomNavigationBar,
      this.defaultShowTitle = false,
      this.body,
      this.padding})
      : super(key: key);
  @override
  _BaseWrapState createState() => _BaseWrapState();
}

class _BaseWrapState extends State<BaseWrap> {
  Widget title;
  bool lastStatus = false;
  ScrollController _scrollController;

  _scrollListener() {
    if (widget.defaultShowTitle == null && isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
        setTitle();
      });
    }
  }

  setTitle() {
    title = lastStatus || widget.defaultShowTitle
        ? widget.appbar.title
        : Container();
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (80 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    if (widget.appbar != null && widget.appbar.title != null) {
      title = widget.appbar.title;
      setTitle();
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      title = DefaultTextStyle(
        style: TextStyle(
          fontSize: 14,
          color: isShrink ? Colors.black : Colors.white,
        ),
        child: Semantics(
          child: title,
          header: true,
        ),
      );
    }

    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: widget.appbar != null
            ? PreferredSize(
                //自定义导航栏高度
                preferredSize: Size.fromHeight(DefaultConfig.appBarHeight),
                child: AppBar(
                    leading: widget.appbar.leading != null
                        ? widget.appbar.leading
                        : null,
                    elevation: widget.appbar.elevation ?? 0,
                    title: title,
                    centerTitle: true,
                    bottom: widget.appbar.bottom,
                    brightness: widget.appbar.brightness ?? Brightness.dark,
                    backgroundColor: widget.appbar.backgroundColor ??
                        Theme.of(context).primaryColor,
                    actions: widget.appbar.actions))
            : null,
        bottomNavigationBar: widget.bottomNavigationBar,
        body: Builder(
          builder: (context) => CustomScrollView(
                controller: _scrollController,
                // key 保证唯一性
                slivers: <Widget>[
                  // 将子部件同 `SliverAppBar` 重叠部分顶出来，否则会被遮挡
                  // SliverOverlapInjector(
                  //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  //         context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          widget.padding ?? EdgeInsets.fromLTRB(15, 5, 15, 15),
                      child: widget.body,
                    ),
                  )
                ],
              ),
        ));

    // return Scaffold(
    //   body: NestedScrollView(
    //       headerSliverBuilder: (context, innerScrolled) => <Widget>[
    //             SliverOverlapAbsorber(
    //                 // 传入 handle 值，直接通过 `sliverOverlapAbsorberHandleFor` 获取即可
    //                 handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
    //                     context),
    //                 child: PreferredSize(
    //                   //自定义导航栏高度
    //                   preferredSize:
    //                       Size.fromHeight(DefaultConfig.appBarHeight),
    //                   child: SliverAppBar(
    //                     pinned: true,
    //                     leading: null,
    //                     title: Text('NestedScroll Demo'),
    //                     expandedHeight: 80.0,
    //                     // flexibleSpace: FlexibleSpaceBar(
    //                     //     background: Image.asset('images/timg.jpg',
    //                     //         fit: BoxFit.cover)),
    //                     // bottom: TabBar(
    //                     //     tabs: _tabs
    //                     //         .map((tab) =>
    //                     //             Text(tab, style: TextStyle(fontSize: 18.0)))
    //                     //         .toList()),
    //                     forceElevated: innerScrolled,
    //                   ),
    //                 ))
    //           ],
    //       body: Builder(
    //         builder: (context) => CustomScrollView(
    //               // key 保证唯一性
    //               slivers: <Widget>[
    //                 // 将子部件同 `SliverAppBar` 重叠部分顶出来，否则会被遮挡
    //                 SliverOverlapInjector(
    //                     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
    //                         context)),
    //                 SliverToBoxAdapter(
    //                   child: widget.body,
    //                 )
    //               ],
    //             ),
    //       )),
    // );
  }
}
