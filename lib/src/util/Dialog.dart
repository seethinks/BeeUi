import 'package:flutter/material.dart';

class Dialog {
  alert(BuildContext context, Text title, Text content, List<Widget> actions) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: title,
              content: content,
              actions: actions,
            ));
  }

  static testDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          // 用Scaffold返回显示的内容，能跟随主题
          return Scaffold(
            backgroundColor: Colors.transparent, // 设置透明背影
            body: Center(
              // 居中显示
              child: Column(
                // 定义垂直布局
                mainAxisAlignment:
                    MainAxisAlignment.center, // 主轴居中布局，相关介绍可以搜下flutter-ui的内容
                children: <Widget>[
                  // CircularProgressIndicator自带loading效果，需要宽高设置可在外加一层sizedbox，设置宽高即可
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('loading'), // 文字
                  // 触发关闭窗口
                  RaisedButton(
                    child: Text('close dialog'),
                    onPressed: () {
                      print('close');
                    },
                  ),
                ],
              ), // 自带loading效果，需要宽高设置可在外加一层sizedbox，设置宽高即可
            ),
          );
        });
  }
}
