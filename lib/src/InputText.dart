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
  final Widget helperText;
  final FocusNode focusNode;
  final TextEditingController controller;
  String label;
  final Widget icon;
  final FormLayout layout;
  final BoxDecoration decoration;
  final Function validator;
  final Function onSave;
  final Widget suffix;
  final Widget prefix;
  final bool enableInteractiveSelection;
  final bool isShowCleanIcon;
  final EdgeInsets margin;

  @override
  _InputTextState createState() => _InputTextState();

  InputText(
      {Key key,
      this.textAlign = TextAlign.left,
      this.disabled = false,
      this.type = InputType.text,
      this.label,
      this.icon,
      this.placeholder,
      this.onChange,
      this.controller,
      this.focusNode,
      this.onSubmit,
      this.enableInteractiveSelection = true,
      this.layout = FormLayout.vertical,
      this.decoration,
      this.helperText,
      this.validator,
      this.onSave,
      this.suffix,
      this.prefix,
      this.autofocus = false,
      this.margin,
      this.isShowCleanIcon = true,
      this.maxLength = 30})
      : super(key: key);
}

class _InputTextState extends State<InputText> {
  FocusNode _focus = new FocusNode();
  bool hasCleanIcon = false;
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      isFocus = _focus.hasFocus;
    });
  }

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

  Widget _renderHd() {
    List<Widget> hd = [];
    if (widget.label != null) {
      var _label = Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text(widget.label,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black87, fontSize: 12.0)));
      hd.add(_label);
    }
    return Row(
      children: hd,
    );
  }

  Widget _renderBd() {
    List<Widget> bd = [];
    if (widget.prefix != null) {
      bd.add(widget.prefix);
    }
    bd.add(Expanded(child: _renderTextField()));

    if (!widget.disabled && widget.isShowCleanIcon && hasCleanIcon) {
      bd.add(_renderCleanIcon());
    }

    if (widget.suffix != null) {
      bd.add(Padding(
        padding: EdgeInsets.only(left: 5),
        child: widget.suffix,
      ));
    }

    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 5, top: 5),
        decoration: new BoxDecoration(
            // color: Theme.of(context).primaryColor,
            border: Border(
                bottom: BorderSide(
                    color: isFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                    width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: bd,
        ));
  }

  Widget _renderFd() {
    List<Widget> fd = [];
    if (widget.helperText != null) {
      fd.add(
          Padding(padding: EdgeInsets.only(top: 5), child: widget.helperText));
    }
    return Row(
      children: fd,
    );
  }

  Widget _renderTextField() {
    return TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        cursorColor: Theme.of(context).primaryColor,
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
          contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5),
          hintText: widget.placeholder,
          hintStyle:TextStyle(color: Colors.black26) ,
          counterText: "",
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     borderSide: BorderSide)
          border: InputBorder.none, //隐藏下划线
          // border: OutlineInputBorder(), //隐藏下划线
        ));
  }

  Widget buildTextField() {
    bool isVertical = widget.layout == FormLayout.vertical;
    Widget main = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_renderBd(), _renderFd()]);
    // children: <Widget>[_renderBd()]);

    // arr.add(isVertical ? textField : Expanded(child: textField));

    //如果是垂直布局
    if (isVertical) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_renderHd(), main]);
    } else {
      return Row(children: <Widget>[_renderHd(), main]);
    }
  }

  Widget _renderCleanIcon() {
    return InkWell(
        child: Icon(BeeIcon.inputClean, size: 15),
        onTap: () {
          _cleanInputValue();
        });
  }

  _cleanInputValue() {
    if (widget.controller != null) {
      widget.controller.clear();
    }
  }

  void _onChange() {
    String text = widget.controller.text;
    if (widget.onChange is Function) {
      widget.onChange(text);
    }

    setState(() {
      hasCleanIcon = text != '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      widget.controller.addListener(_onChange);
    }

    // icon和label同时存在时，icon的优先级最高
    if (widget.icon != null) {
      widget.label = null;
    }

    // decoration = BoxDecoration(
    //   border: Border(bottom: BorderSide(color: Color(0xFFe8e8e8), width: 1)),
    // );

    return Container(
      padding: widget.margin ?? EdgeInsets.fromLTRB(0, 8, 0, 8),
      // padding: EdgeInsets.symmetric(vertical: 8),
      child: buildTextField(),
    );
  }
}
