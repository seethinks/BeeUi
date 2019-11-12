import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final Function onChange;
  final Widget label;
  final bool checked;
  const CheckBox({Key key, this.checked = false, this.onChange, this.label})
      : super(key: key);
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _checkboxSelected; //维护复选框状态

  void initState() {
    _checkboxSelected = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> arr = [
      Transform.scale(
          scale: 0.8,
          child: Checkbox(
            tristate: true,
            value: _checkboxSelected,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Theme.of(context).accentColor, //选中时的颜色
            onChanged: (value) {
              this.onChange();
            },
          ))
    ];

    if (widget.label != null) {
      arr.add(widget.label);
    }

    return GestureDetector(
      onTap: onChange,
      child: Row(
        children: arr,
      ),
    );
  }

  void onChange() {
        if(!mounted) return;
    setState(() {
      _checkboxSelected = !_checkboxSelected;
      if (widget.onChange is Function) {
        widget.onChange(_checkboxSelected);
      }
    });
  }
}
