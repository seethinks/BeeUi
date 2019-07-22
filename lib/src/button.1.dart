import 'package:flutter/material.dart';

import '../enums.dart';

class Button extends StatefulWidget {
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

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == ButtonType.primary) {
      return FlatButton(
        key: globalKey,
        // padding: EdgeInsets.symmetric(vertical: 10),
        onPressed: widget.disabled == true ? null : _log,
        child: Text(widget.text,
            style: TextStyle(
                fontSize:14)),
        color: widget.color ?? Theme.of(context).buttonColor,
        textColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //       color: Colors.white,
        //       width: 1,
        //     ),
        //     borderRadius: BorderRadius.circular(radius)),
      );
    }

    if (widget.type == ButtonType.gost) {
      return OutlineButton(
        onPressed: widget.disabled == true ? null : _log,
        child: Text(widget.text),
        borderSide: new BorderSide(
            color: widget.color ?? Theme.of(context).primaryColor),
        textColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius)),
      );
    }
  }

  final GlobalKey globalKey = GlobalKey();
  Size widgetSize;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    _getSizes();
  }

  _getSizes() {
    final RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();

    setState(() {
      widgetSize = renderBoxRed.size;
      //  print("SIZE of Red: $widgetSize");
    });
  }

  _log() {
    if (widget.onPress is Function) {
      widget.onPress();
    }
  }
}
