import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class CortadoRaisedButton extends StatefulWidget {
  const CortadoRaisedButton(
      {Key key,
      this.text,
      this.onTap,
      this.color,
      this.textStyle,
      this.enabled,
      this.fontSize,
      this.width,
      this.height,
      this.backgroundColor})
      : super(key: key);
  final String text;
  final Color color;
  final Function onTap;
  final TextStyle textStyle;
  final bool enabled;
  final double fontSize;
  final double width;
  final double height;
  final Color backgroundColor;

  @override
  _CortadoRaisedButtonState createState() => _CortadoRaisedButtonState();
}

class _CortadoRaisedButtonState extends State<CortadoRaisedButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return widget.enabled ?? true
        ? GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                _isPressed = true;
              });
            },
            onTapUp: (TapUpDetails details) {
              setState(() {
                _isPressed = false;
              });
            },
            onTap: widget.onTap,
            child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.light,
                  borderRadius: BorderRadius.circular(8.0),
                  border: _isPressed
                      ? Border(
                          bottom: BorderSide(color: Colors.grey, width: 10.0))
                      : null,
                ),
                height: widget.height ?? 50,
                width: widget.width ?? 150,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      widget.text,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: widget.textStyle ??
                          TextStyle(
                            fontFamily: kFontFamilyNormal,
                            fontSize: widget.fontSize,
                            color: widget.color ?? AppColors.light,
                          ),
                    ),
                  ),
                )))
        : SizedBox.shrink();
  }
}
