import 'dart:async';
import 'dart:math';
import 'package:beeui/enums.dart';
import 'package:beeui/src/button.dart';
import 'package:flutter/material.dart';

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

  BaseListLoad(Function fetchData, Function renderRow,
      {Widget initLoadingView, int pageSize = 10}) {
    this.fetchData = fetchData;
    this.renderRow = renderRow;
    this.initLoadingView = initLoadingView;
    this.pageSize = pageSize;
  }

  @override
  _BaseListLoadState createState() => _BaseListLoadState();
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
    _beginHeaderRefresh();
  }

  Future getData() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isFirst = false;
        isInitError = true;
      });
    });
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
    setState(() {
      isHeaderRefreshing = true;
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 初始化的时候显示加载中
    if (isFirst) {
      return _renderLoading();
    }

    //初始化出现异常的时候
    if (isInitError) {
      return _renderInitError();
    }

    print("list-----${list}${list.length}");

    if (list.length == 0) {
      return _renderEmptyData();
    }

    return new Container(
      child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: _renderRow,
            itemCount: list.length + 1,
            controller: _scrollController,
          )),
    );
  }

  Widget _renderInitError() {
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '亲的网络有点问题~',
            style: TextStyle(fontSize: 16.0),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Button("重新加载", type: ButtonType.gost, onPress: _onReloadBtn)
        ],
      ),
    );
  }

  @override
  _onReloadBtn() {
    setState(() {
      isFirst = true;
      _beginHeaderRefresh();
    });
  }

//
  Widget _renderLoading() {
    return widget.initLoadingView != null
        ? widget.initLoadingView
        : Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    strokeWidth: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '加载中',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _renderRow(context, index) {
    if (index < list.length) {
      print("${index}");
      return widget.renderRow(list[index], index);
    }
    return _getMoreLoadingWidget();
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

  Widget _renderEmptyData() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '暂无数据~',
          style: TextStyle(fontSize: 16.0),
        )
      ],
    ));
  }

  Future<void> _onRefresh() async {
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

  _setViewState(Map<String, dynamic> data) {
    // 获取总的条数
    var _data = data["data"];
    var totalCount = data["totalCount"];
    int totalPage = (totalCount / widget.pageSize).ceil();

    setState(() {
      try {
        list = new List.from(list)..addAll(_data);
        if (pageIndex < totalPage) {
          // 还有数据可以加载
          footerState = RefreshState.CanLoadMore;
          // 下次加载从第几条数据开始
          pageIndex = pageIndex + 1;
        } else {
          footerState = RefreshState.NoMoreData;
        }

        _endRefreshing(footerState);
      } catch (e) {
        _endRefreshing(RefreshState.Failure);
      }
    });
  }

  _endRefreshing(String footerState) {
    String footerRefreshState = footerState;
    setState(() {
      footerState = footerRefreshState;
      isInitError = isFirst && footerState == RefreshState.Failure;
      isHeaderRefreshing = false;
      isFooterRefreshing = false;
      isFirst = false;
    });
  }
}
