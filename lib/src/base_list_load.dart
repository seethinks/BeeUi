import 'dart:async';
import 'dart:math';
import 'package:beeui/enums.dart';
import 'package:beeui/src/button.dart';
import 'package:flutter/material.dart';

import 'icon.dart';

class RefreshState {
  static String Idle = 'Idle'; // 初始状态，无刷新的情况
  static String CanLoadMore = 'CanLoadMore'; // 可以加载更多，表示列表还有数据可以继续加载
  static String Refreshing = 'Refreshing'; // 正在刷新中
  static String NoMoreData = 'NoMoreData'; // 没有更多数据了
  static String Failure = 'Failure'; // 刷新失败
}

class BaseListLoad extends StatefulWidget {
  Function renderRow;
  Function fetchData;
  Widget initLoadingView;
  int pageSize;
  bool desablePullUp; // 禁止上拉
  bool desablePullDown; //禁止下拉
  bool isNeedScroll;
  bool isReload;

  ValueNotifierData reLoadData = new ValueNotifierData("reLoad");
  ValueNotifierData filterData = new ValueNotifierData("filter");

  BaseListLoad(
    this.fetchData,
    this.renderRow, {
    Key key,
    this.initLoadingView,
    this.pageSize = 10,
    this.isReload,
    this.isNeedScroll = true,
  }) : super(key: key);

  // _BaseListLoadState baseListLoad = new _BaseListLoadState();
  @override
  _BaseListLoadState createState() => new _BaseListLoadState();

  void reload() {
    var a = Random().nextInt(999999999);
    reLoadData.value = a.toString();
  }

  // @override
  // _BaseListLoadState createState() => _BaseListLoadState();
}

class _BaseListLoadState extends State<BaseListLoad> {
  List<dynamic> list = new List();
  bool isFirst = true; //是否是第一次加载
  bool isHeaderRefreshing = false; //头部是否加载中
  bool isFooterRefreshing = false; //底部是否加载中
  bool isInitError = true; //是否在第一加载错误是显示错误界面
  String footerState = RefreshState.Idle;
  int pageIndex = 1;

  ScrollController _scrollController = ScrollController(); //listview的控制器

  @override
  void initState() {
    _scrollController.addListener(_onScrollHandle);
    _beginHeaderRefresh();
    widget.reLoadData.addListener(_handleReloadValueChanged);
  }

  void _handleReloadValueChanged() {
    setState(() {
      isFirst = true;
    });
    reload();
  }

  didchangedependencies() {
    print("object");
  }

  _onScrollHandle() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (footerState == RefreshState.CanLoadMore) {
        _beginLoadMore();
      }
    }
  }

  /// 开始下拉刷新
  @override
  _beginHeaderRefresh() {
    if (_shouldStartHeaderRefreshing()) {
      _startHeaderRefreshing();
    }
  }

  _shouldStartHeaderRefreshing() {
    if (footerState == RefreshState.Refreshing ||
        isHeaderRefreshing ||
        isFooterRefreshing) {
      return false;
    }
    return true;
  }

  _startHeaderRefreshing() {
    isHeaderRefreshing = true;
    _onRefresh();
  }

  /// 开始加载更多
  @override
  _beginLoadMore() {
    if (_shouldStartLoadMore()) {
      _startLoadMore();
    }
  }

  _shouldStartLoadMore() {
    if (footerState == RefreshState.Refreshing ||
        isHeaderRefreshing ||
        isFooterRefreshing) {
      return false;
    }
    return true;
  }

  _startLoadMore() {
    setState(() {
      isFooterRefreshing = true;
      _getMoreData();
    });
  }

  @override
  Widget build(BuildContext context) {
    //初始化的时候显示加载中
    if (isFirst) {
      return _renderLoading();
    }

    //初始化出现异常的时候
    if (isInitError) {
      return _renderInitError();
    }
    if (list.length == 0) {
      return _renderEmptyData();
    }

    return new Container(
      child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            physics: widget.isNeedScroll
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            shrinkWrap: !widget.isNeedScroll,
            itemBuilder: _renderRow,
            itemCount: list.length + 1,
            controller: _scrollController,
          )),
    );
  }

  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _renderInitError() {
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            BeeIcon.netError,
            size: 100,
            color: Colors.grey[500],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '亲的网络有点问题~',
              style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Button(
            "重新加载",
            type: ButtonType.gost,
            onPress: _onReloadBtn,
            radius: 30,
          )
        ],
      ),
    );
  }

  @override
  _onReloadBtn() {
    reload();
  }

  reload() {
    _beginHeaderRefresh();
  }

//
  Widget _renderLoading() {
    List<Widget> arr = <Widget>[];

    if (widget.initLoadingView != null) {
      arr.add(widget.initLoadingView);
    } else {
      arr.add(CircularProgressIndicator(
        strokeWidth: 3.0,
      ));
      arr.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '加载中',
          style: TextStyle(fontSize: 16.0),
        ),
      ));
    }
    return Center(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: arr)));
  }

  Widget _renderRow(context, index) {
    if (index < list.length) {
      return widget.renderRow(list[index], index);
    }

    //可以加载更多
    if (footerState == RefreshState.CanLoadMore) {
      return _getMoreLoadingWidget();
    }
    return _noMore();
  }

  Widget _getMoreLoadingWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _noMore() {
    return Container();
    // return Center(
    //   child: Padding(
    //     padding: EdgeInsets.all(10.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         Text(
    //           '暂无更多',
    //           style: TextStyle(fontSize: 16.0),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _renderEmptyData() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          BeeIcon.noData,
          size: 70,
          color: Colors.grey[300],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            '暂无数据',
            style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
          ),
        )
      ],
    ));
  }

  Future<void> _onRefresh() async {
    pageIndex = 1;
    await _fetchData();
  }

  _fetchData() async {
    if (widget.fetchData != null) {
      try {
        var fullData = await widget.fetchData(pageIndex, widget.pageSize);

        if (fullData is Map) {
          _setViewState(fullData);
        } else {
          _endRefreshing(RefreshState.Failure);
        }
      } catch (e) {
        _endRefreshing(RefreshState.Failure);
      }
    }
  }

  _getMoreData() {
    _fetchData();
  }

  _setViewState(Map<String, dynamic> data) async {
    // 获取总的条数
    var _data = data["data"];
    bool isNoMore = _data.length != widget.pageSize;
    String footerState;

    setState(() {
      try {
        // 第一次或者重新下拉加载的
        if (pageIndex == 1) {
          list = new List.from([])..addAll(_data);
        } else {
          list.addAll(_data);
        }
      } catch (e) {
        _endRefreshing(RefreshState.Failure);
      }
    });

    if (!isNoMore) {
      // 还有数据可以加���
      footerState = RefreshState.CanLoadMore;
      // 下次加载从第几��数��开始
      pageIndex = pageIndex + 1;
    } else {
      footerState = RefreshState.NoMoreData;
    }
    _endRefreshing(footerState);
  }

  _endRefreshing(String footerRefreshState) {
    footerState = footerRefreshState;
    isHeaderRefreshing = false;
    isFooterRefreshing = false;
    setState(() {
      isInitError = isFirst && footerState == RefreshState.Failure;
      isFirst = false;
    });
  }
}

class ValueNotifierData extends ValueNotifier<String> {
  ValueNotifierData(value) : super(value);
}
