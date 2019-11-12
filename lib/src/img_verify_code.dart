import 'package:flutter/material.dart';

class ImgVerifyCode extends StatefulWidget {
  final String url;
  const ImgVerifyCode(this.url, {Key key}) : super(key: key);
  @override
  _ImgVerifyCodeState createState() => _ImgVerifyCodeState();
}

class _ImgVerifyCodeState extends State<ImgVerifyCode> {
  bool isRefresh;
  bool isError;
  NetworkImage imageCode;
  int count = 0;

  @override
  void initState() {
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: imageCode == null
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ))
            : GestureDetector(
                onTap: _handleTap,
                child: Container(
                  child: new Image(
                    gaplessPlayback: false,
                    fit: BoxFit.contain,
                    image: imageCode,
                  ),
                ),
              ));
  }

  _handleTap() {
    refresh();
  }

  void refresh() {
        if(!mounted) return;
    setState(() {
      count = count + 1;

      imageCode = NetworkImage("${widget.url}?t=${count}");
      print(imageCode);
    });
  }
}
