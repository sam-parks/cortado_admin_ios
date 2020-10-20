import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CortadoAdminLoadingIndicator extends StatefulWidget {
  const CortadoAdminLoadingIndicator({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CortadoAdminLoadingIndicatorState();
}

class _CortadoAdminLoadingIndicatorState
    extends State<CortadoAdminLoadingIndicator> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        setState(() {
          opacity = 0.2;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 1000),
      onEnd: () {
        opacity == 0.2
            ? setState(() {
                opacity = 1.0;
              })
            : setState(() {
                opacity = 0.2;
              });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: SvgPicture.asset(
          'images/coffee_shop.svg',
          height: 40,
        ),
      ),
    );
  }
}
