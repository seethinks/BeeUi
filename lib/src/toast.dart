import 'package:beeui/src/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums.dart';

class Toast {
  // 工厂模式
  factory Toast() => _getInstance();
  static Toast get instance => _getInstance();
  static Toast _instance;
  static ToastType _type;

  Toast._internal() {}
  static Toast _getInstance() {
    if (_instance == null) {
      _instance = new Toast._internal();
    }
    return _instance;
  }

  ToastView preToast;
  _show(BuildContext context, String msg, [Alignment direction]) {
    preToast?.dismiss();
    preToast = null;

    var overlayState = Overlay.of(context);

    var controllerShowAnim = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var controllerShowOffset = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 350),
    );
    var controllerHide = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var opacityAnim1 =
        new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
    var controllerCurvedShowOffset = new CurvedAnimation(
        parent: controllerShowOffset, curve: _BounceOutCurve._());
    var offsetAnim =
        new Tween(begin: 30.0, end: 0.0).animate(controllerCurvedShowOffset);
    var opacityAnim2 = new Tween(begin: 1.0, end: 0.0).animate(controllerHide);

    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context) {
      return ToastWidget(
        opacityAnim1: opacityAnim1,
        opacityAnim2: opacityAnim2,
        offsetAnim: offsetAnim,
        child: _buildToastLayout(msg, direction),
      );
    });

    var toastView = ToastView();
    toastView.overlayEntry = overlayEntry;
    toastView.controllerShowAnim = controllerShowAnim;
    toastView.controllerShowOffset = controllerShowOffset;
    toastView.controllerHide = controllerHide;
    toastView.overlayState = overlayState;
    preToast = toastView;
    toastView._show();
  }

  info(BuildContext context, String msg, [Alignment direction]) {
    _type = ToastType.INFO;
    _show(context, msg, direction);
  }

  success(BuildContext context, String msg, [Alignment direction]) {
    _type = ToastType.SUCCESS;
    _show(context, msg, direction);
  }

  fail(BuildContext context, String msg, [Alignment direction]) {
    _type = ToastType.FAIL;
    _show(context, msg, direction);
  }

  loading(BuildContext context, [String msg = "加载中", Alignment direction]) {
    _type = ToastType.LOADING;
    _show(context, msg, direction);
  }

  Widget _renderContent(BuildContext context, String msg) {
    List arr = <Widget>[
      Text(
        "${msg}",
        style: TextStyle(color: Colors.white),
      )
    ];

    if (_type != ToastType.INFO) {
      var icon;
      arr.insert(0, Padding(padding: EdgeInsets.only(bottom: 5)));
      if (_type == ToastType.LOADING) {
        icon = CupertinoActivityIndicator(
          radius: 12,
        );
      }
      if (_type == ToastType.SUCCESS) {
        icon = Icon(BeeIcon.success, color: Colors.white);
      }
      if (_type == ToastType.FAIL) {
        icon = Icon(BeeIcon.fail, color: Colors.white);
      }
      arr.insert(0, icon);
    }

    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: arr));
  }

  LayoutBuilder _buildToastLayout(String msg, Alignment direction) {
    return LayoutBuilder(builder: (context, constraints) {
      return IgnorePointer(
        ignoring: true,
        child: Container(
          // color: Color.fromRGBO(0, 0, 0, 0.4),
          child: Material(
            color: Colors.white.withOpacity(0),
            child: Container(
              child: Container(
                child: _renderContent(context, msg),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              margin: EdgeInsets.only(
                bottom: constraints.biggest.height * 0.05,
                left: constraints.biggest.width * 0.2,
                right: constraints.biggest.width * 0.2,
              ),
            ),
          ),
          alignment: direction ?? Alignment.center,
        ),
      );
    });
  }
}

class ToastA {
  // 工厂模式
  factory ToastA() => _getInstance();
  static ToastA get instance => _getInstance();
  static ToastA _instance;

  static ToastA _getInstance() {
    if (_instance == null) {
      _instance = new ToastA();
    }
    return _instance;
  }
}

class ToastView {
  OverlayEntry overlayEntry;
  AnimationController controllerShowAnim;
  AnimationController controllerShowOffset;
  AnimationController controllerHide;
  OverlayState overlayState;
  bool dismissed = false;

  _show() async {
    overlayState.insert(overlayEntry);
    controllerShowAnim.forward();
    controllerShowOffset.forward();
    await Future.delayed(Duration(milliseconds: 3500));
    this.dismiss();
  }

  dismiss() async {
    if (dismissed) {
      return;
    }
    this.dismissed = true;
    controllerHide.forward();
    await Future.delayed(Duration(milliseconds: 250));
    overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> opacityAnim1;
  final Animation<double> opacityAnim2;
  final Animation<double> offsetAnim;

  ToastWidget(
      {this.child, this.offsetAnim, this.opacityAnim1, this.opacityAnim2});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: opacityAnim1,
      child: child,
      builder: (context, child_to_build) {
        return Opacity(
          opacity: opacityAnim1.value,
          child: AnimatedBuilder(
            animation: offsetAnim,
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, offsetAnim.value),
                child: AnimatedBuilder(
                  animation: opacityAnim2,
                  builder: (context, _) {
                    return Opacity(
                      opacity: opacityAnim2.value,
                      child: child_to_build,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _BounceOutCurve extends Curve {
  const _BounceOutCurve._();

  @override
  double transform(double t) {
    t -= 1.0;
    return t * t * ((2 + 1) * t + 2) + 1.0;
  }
}
