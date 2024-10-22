import 'package:auto_size_text/auto_size_text.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    Key key,
    this.content,
    this.title,
    this.height,
    this.width,
    this.innerColor,
    this.outerColor,
    this.innerHorizontalPadding,
  }) : super(key: key);
  final Widget content;
  final String title;
  final double height;
  final double width;
  final Color innerColor;
  final Color outerColor;

  final double innerHorizontalPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        height: height ?? SizeConfig.screenHeight * .5,
        width: width ?? SizeConfig.screenWidth * .4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    color: outerColor ?? AppColors.dark,
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 12),
                      child: AutoSizeText(
                        title,
                        style: TextStyles.kLargeCreamTextStyle,
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        left: innerHorizontalPadding ?? 0,
                        right: innerHorizontalPadding ?? 0),
                    elevation: 0.0,
                    child: Container(
                        height: (title != null)
                            ? (height ?? SizeConfig.screenHeight * .5) - 60
                            : (height ?? SizeConfig.screenHeight * .5),
                        width: (width ?? SizeConfig.screenWidth * .4) - 20.0,
                        padding: const EdgeInsets.all(15),
                        child: Container(child: content ?? Container())),
                    color: innerColor ?? AppColors.light,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
