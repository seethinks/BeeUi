import 'package:flutter/material.dart';

import '../enums.dart';

class Button extends StatelessWidget {
  ButtonType type;
  String size;
  String text;
  final double radius;
  final Color color;
  bool disabled;
  Function onPress;

  Button(
    this.text, {
    Key key,
    this.disabled,
    this.type = ButtonType.primary,
    this.size,
    this.color,
    this.radius = 4,
    this.onPress,
  }) : super(key: key);

  void _getWH() {
    final containerWidth = globalKey.currentContext.size.width;
    final containerHeight = globalKey.currentContext.size.height;
    print('Container widht is $containerWidth, height is $containerHeight');
  }

  final GlobalKey globalKey = GlobalKey();

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    _getSizes();
  }

  _getSizes() {
    final RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print("SIZE of Red: $sizeRed");
  }

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.primary) {
      return FlatButton(
        key: globalKey,
        padding: EdgeInsets.symmetric(vertical: 10),
        onPressed: disabled == true ? null : _log,
        child: Text(text, style: TextStyle(fontSize: 12)),
        color: color ?? Theme.of(context).buttonColor,
        textColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //       color: Colors.white,
        //       width: 1,
        //     ),
        //     borderRadius: BorderRadius.circular(radius)),
      );
    }

    if (type == ButtonType.gost) {
      return OutlineButton(
        onPressed: disabled == true ? null : _log,
        child: Text(text),
        borderSide:
            new BorderSide(color: color ?? Theme.of(context).primaryColor),
        textColor: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      );
    }
  }

  _log() {
    if (onPress is Function) {
      onPress();
    }
  }
}
