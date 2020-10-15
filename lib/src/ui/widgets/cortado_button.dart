import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class CortadoButton extends StatelessWidget {
  const CortadoButton(
      {Key key,
      this.text,
      this.onTap,
      this.color,
      this.textStyle,
      this.lineDist,
      this.enabled,
      this.fontSize,
      this.width,
      this.lineWidth,
      this.height})
      : super(key: key);
  @required
  final String text;
  final Color color;
  final Function onTap;
  final TextStyle textStyle;
  final bool enabled;
  final double lineDist;
  final double fontSize;
  final double width;
  final double lineWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return enabled ?? true
        ? Container(
            height: height ?? 50,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: width,
                    child: GestureDetector(
                        child: AutoSizeText(
                          text,
                          style: textStyle ??
                              TextStyle(
                                fontFamily: kFontFamilyNormal,
                                fontSize: fontSize ?? 20,
                                color: color ?? AppColors.dark,
                              ),
                        ),
                        onTap: onTap),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: lineDist ?? 8.0,
                  ),
                  color: color ?? AppColors.dark,
                  height: 1.0,
                  width: lineWidth ?? 100,
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
