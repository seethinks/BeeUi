import 'package:beeui/bee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../enums.dart';
import '../icon.dart';

class LoadNodataWidget extends StatelessWidget {
  final String msg;
  final String buttonText;
  final VoidCallback onPressed;
  LoadNodataWidget({this.msg = "暂无数据~", this.buttonText, this.onPressed});
  @override
  Widget build(BuildContext context) {
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
            msg,
            style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
          ),
        ),
        // Padding(padding: EdgeInsets.only(bottom: 10)),
        // Button(
        //   "重新加载",
        //   color: Theme.of(context).buttonColor,
        //   type: ButtonType.gost,
        //   onPress: onPressed,
        //   radius: 30,
        // )
      ],
    ));
  }
}

class LoadErrorWidget extends StatelessWidget {
  final String msg;
  final VoidCallback onPressed;
  LoadErrorWidget({this.msg = "亲的网络有点问题~", this.onPressed});
  @override
  Widget build(BuildContext context) {
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
              msg,
              style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Button(
            "重新加载",
            color: Theme.of(context).buttonColor,
            type: ButtonType.gost,
            onPress: onPressed,
            radius: 30,
          )
        ],
      ),
    );
  }
}
