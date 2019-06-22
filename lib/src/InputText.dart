import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../enums.dart';
import 'icon.dart';

class InputText extends StatefulWidget {
  final TextAlign textAlign; // 对齐方式
  final int maxLength; //最大长度
  final InputType type; //类型
  final bool disabled; // 是否禁用
  final Function onChange; //内容改变回调
  final Function onSubmit; //提交回调
  final bool autofocus; ////是否自动对焦
  final String placeholder;
  final String helperText;
  String label;
  final Widget icon;
  final String defaultValue; //默认值
  final FormLayout layout;
  final BoxDecoration decoration;
  final Function validator;
  final Function onSave;
  final Widget extra;
  final Widget prefix;
  final bool enableInteractiveSelection;
  final bool isShowBorder;

  @override
  _InputTextState createState() => _InputTextState();

  InputText(
      {Key key,
      this.textAlign = TextAlign.left,
      this.disabled = false,
      this.type = InputType.text,
      this.label,
      this.defaultValue,
      this.icon,
      this.placeholder,
      this.onChange,
      this.onSubmit,
      this.enableInteractiveSelection = true,
      this.layout = FormLayout.horizontal,
      this.decoration,
      this.helperText,
      this.validator,
      this.onSave,
      this.extra,
      this.prefix,
      this.autofocus = false,
      this.isShowBorder = false,
      this.maxLength = 30})
      : super(key: key);
}

class _InputTextState extends State<InputText> {
  final TextEditingController controller = new TextEditingController();

  bool isShowCleanIcon = false;

  TextInputType _keyboardType() {
    if (widget.type == InputType.phone) {
      return TextInputType.phone;
    }

    return TextInputType.text;
  }

  List<TextInputFormatter> _inputFormatters() {
    List<TextInputFormatter> arr = [];

    if (widget.type == InputType.phone) {
      arr.add(WhitelistingTextInputFormatter.digitsOnly);
    }
    // ,
    // LengthLimitingTextInputFormatter(11),
    // WhitelistingTextInputFormatter(RegExp("[0-9.]"))
    return arr;
  }

  Widget buildTextField() {
    const TextStyle labelStyle = TextStyle(color: Colors.white, fontSize: 12.0);
    bool isVertical = widget.layout == FormLayout.vertical;
    var arr = <Widget>[];
    if (widget.label != null) {
      var _label = Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child:
              Text(widget.label, textAlign: TextAlign.left, style: labelStyle));
      arr.add(_label);
    }

    var textField = TextFormField(
        controller: controller,
        maxLength: widget.maxLength,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        maxLines: 1, //最大行数
        autocorrect: true, //是否自动更正
        keyboardType: _keyboardType(),
        autofocus: widget.autofocus, //是否自动对焦
        obscureText: widget.type == InputType.password, //密码自动隐藏文本为*
        textAlign: widget.textAlign, //文本对齐方式
        // style: TextStyle(fontSize: 12.0, color: Colors.white), //输入文本的样式
        inputFormatters: _inputFormatters(), //允许的输入格式
        // onChanged: (text) {
        //   if (onChange is Function) {
        //     onChange(text);
        //   }
        // },
        // onSubmitted: (text) {
        //   if (onSubmit is Function) {
        //     onSubmit(text);
        //   }
        // },
        validator: (val) {
          print("---------val${val}");
          if (widget.validator is Function) {
            return widget.validator(val);
          }
          return null;
        },
        onSaved: (val) {
          print("---------onSaved${val}");
          if (widget.onSave is Function) {
            return widget.onSave(val);
          }
          return null;
        },
        enabled: !widget.disabled, //是否禁用
        // onFieldSubmitted: (String value) {
        //   setState(() {
        //     _deskripsiController.text = value;
        //   });
        // },
        decoration: InputDecoration(
            // prefixText: layout == InputTextLayout.horizontal ? label : null,
            // prefixStyle: labelStyle,
            contentPadding: EdgeInsets.all(8),
            helperText: widget.helperText,
            hintText: widget.placeholder,
            suffixIcon: _renderSuffixIcon(),
            counterText: "",
            // border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(15),
            //     borderSide: BorderSide)
            // border: Border.none, //隐藏下划线
            // border: OutlineInputBorder(), //隐藏下划线
            ));

    if (widget.prefix != null) {
      arr.add(widget.prefix);
    }

    arr.add(isVertical ? textField : Expanded(child: textField));

    if (widget.extra != null) {
      arr.add(widget.extra);
    }
    //如果是垂直布局
    if (isVertical) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: arr);
    } else {
      return Row(children: arr);
    }
  }

  Widget _renderSuffixIcon() {
    if (!isShowCleanIcon) {
      return null;
    }

//  widget.isShowBorder
//               ? OutlineInputBorder()
//               : InputBorder.none
    return IconButton(
        icon: Icon(BeeIcon.inputClean),
        onPressed: () {
          cleanInputValue();
        });
  }

  cleanInputValue() {
    if (controller != null) {
      controller.clear();
    }
  }

  void _onChange() {
    String text = controller.text;
    if (widget.onChange is Function) {
      widget.onChange(text);
    }

    setState(() {
      isShowCleanIcon = text != '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultValue != null) {
      controller.text = widget.defaultValue;
    }
    controller.addListener(_onChange);

    // icon和label同时存在时，icon的优先级最高
    if (widget.icon != null) {
      widget.label = null;
    }

    // decoration = BoxDecoration(
    //   border: Border(bottom: BorderSide(color: Color(0xFFe8e8e8), width: 1)),
    // );

    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),

      // padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      // height: 40.0,
      child: buildTextField(),
    );
  }
}
