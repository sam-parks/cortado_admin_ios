import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:flutter/material.dart';

class InheritedDrinkProvider extends InheritedWidget {
  InheritedDrinkProvider(this.drink, {Key key, this.child})
      : super(key: key, child: child);
  final Drink drink;
  final Widget child;

  static InheritedDrinkProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDrinkProvider>();
  }

  @override
  bool updateShouldNotify(InheritedDrinkProvider oldWidget) {
    return drink != oldWidget.drink;
  }
}
