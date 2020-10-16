import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class CortadoFatButton extends StatelessWidget {
  const CortadoFatButton(
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
  Widget build(BuildContext context) {
    return enabled ?? true
        ? GestureDetector(
            onTap: onTap,
            child: Container(
                decoration: BoxDecoration(
                    color: backgroundColor ?? AppColors.light,
                    borderRadius: BorderRadius.circular(8.0)),
                height: height ?? 50,
                width: width ?? 150,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      text,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          TextStyle(
                            fontFamily: kFontFamilyNormal,
                            fontSize: fontSize,
                            color: color ?? AppColors.light,
                          ),
                    ),
                  ),
                )))
        : SizedBox.shrink();
  }
}
