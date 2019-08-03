import 'package:beeui/src/icon.dart';
import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final Text title;
  final Widget icon;
  final Widget thum;
  final Function onPress;
  final bool arrow;
  final bool disabled;
  final Widget extra;
  final int labelNumber;
  final Widget child;
  final BoxDecoration decoration;

  Cell(
      {Key key,
      this.title,
      this.icon,
      this.thum,
      this.onPress,
      this.arrow = false,
      this.extra,
      this.disabled = false,
      this.decoration,
      this.labelNumber = 4,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arr = <Widget>[];

    if (thum != null) {
      arr.add(
          Container(margin: EdgeInsets.fromLTRB(15, 0, 15, 0), child: thum));
    }

    arr.add(Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: 1))),
        height: 48,
        child: Row(
          children: <Widget>[
            _renderCenter(context),
            _renderRight(context),
          ],
        ),
      ),
    ));

    //

    return Container(
        child: InkWell(
            key: key,
            onTap: () {
              if (disabled is bool &&
                  disabled == false &&
                  onPress is Function) {
                onPress();
              }
            },
            child: Row(children: arr)));
  }

  Widget _renderCenter(BuildContext context) {
    var renderArr = <Widget>[];

    if (icon != null) {
      renderArr.add(Padding(
        child: icon,
        padding: EdgeInsets.only(left: 15, right: 10),
      ));
    }

    if (title != null) {
      renderArr.add(title);
    }

    if (child != null) {
      renderArr.add(child);
    }
    return Expanded(
        flex: 1,
        child: Container(
            // decoration: BoxDecoration(color: Colors.red),
            child: Row(children: renderArr)));
  }

  Widget _renderRight(BuildContext context) {
    var renderArr = <Widget>[];

    if (extra != null) {
      renderArr.add(extra);
    }

    if (arrow) {
      renderArr.add(Icon(
        BeeIcon.rightArrow,
        size: 18,
      ));
    }

    if (renderArr.length > 0) {
      return Container(
        padding: EdgeInsets.only(right: 15),
        child: Row(
          children: renderArr,
        ),
      );
    }
    return Container();
  }
}
