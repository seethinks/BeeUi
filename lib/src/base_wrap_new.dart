import 'package:flutter/material.dart';

import '../config.dart';

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
    print("object");
        if(!mounted) return;
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            //自定义导航栏高度
            preferredSize: Size.fromHeight(DefaultConfig.appBarHeight),
            child: AppBar(
                leading: widget.appbar.leading != null
                    ? widget.appbar.leading
                    : null,
                elevation: widget.appbar.elevation ?? 0,
                title: title,
                centerTitle: true,
                brightness: widget.appbar.brightness ?? Brightness.dark,
                backgroundColor: widget.appbar.backgroundColor ?? Colors.white,
                actions: widget.actions)),
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
                    child: widget.body,
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

class DemoHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.pink,
        alignment: Alignment.center,
        child: Text('我是一个头部部件',
            style: TextStyle(color: Colors.white, fontSize: 30.0)));
  } // 头部展示内容

  @override
  double get maxExtent => 300.0; // 最大高度

  @override
  double get minExtent => 100.0; // 最小高度

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) =>
      false; // 因为所有的内容都是固定的，所以不需要更新
}
