import 'package:flutter/material.dart';

class LatteLoader extends StatefulWidget {
  LatteLoader({Key key}) : super(key: key);

  @override
  _LatteLoaderState createState() => _LatteLoaderState();
}

class _LatteLoaderState extends State<LatteLoader>
    with TickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    controller.forward(from: 0.0);
    controller.addListener(() {
      setState(() {
        if (controller.status == AnimationStatus.completed) {
          controller.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage('images/latte_spin.png')))));
  }
}
