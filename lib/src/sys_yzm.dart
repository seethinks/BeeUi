import 'dart:async';

import 'package:flutter/material.dart';

class SysYzm extends StatefulWidget {
  final Function onPress;

  const SysYzm({Key key, this.onPress}) : super(key: key);
  @override
  _SysYzmState createState() => _SysYzmState();
}

class _SysYzmState extends State<SysYzm> {
  int _seconds = 0;

  String _verifyStr = '获取验证码';

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: (_seconds == 0 || widget.onPress != null) ? _onTap : null,
      child: new Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 36.0,
        decoration: new BoxDecoration(
            border: new Border.all(
                width: 1.0, color: Theme.of(context).textTheme.body1.color),
            borderRadius: BorderRadius.all(const Radius.circular(4))),
        child: new Text(
          '$_verifyStr',
          style: new TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  _onTap() {
    if (!mounted) return;
    setState(() {
      _verifyStr = '发送中';
    });
    widget.onPress(_begin);
  }

  _begin(bool isBegin) {
    if (!mounted) return;
    if (isBegin) {
      setState(() {
        _startTimer();
      });
    } else {
      setState(() {
        _verifyStr = '重新发送';
      });
    }
  }

  _startTimer() {
    if (!mounted) return;
    _seconds = 60;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '${_seconds}s';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
