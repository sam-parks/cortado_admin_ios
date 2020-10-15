import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:flutter/material.dart';

class InheritedFoodProvider extends InheritedWidget {
  InheritedFoodProvider(this.food, {Key key, this.child})
      : super(key: key, child: child);
  final Food food;
  final Widget child;

  static InheritedFoodProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedFoodProvider>();
  }

  @override
  bool updateShouldNotify(InheritedFoodProvider oldWidget) {
    return food != oldWidget.food;
  }
}
