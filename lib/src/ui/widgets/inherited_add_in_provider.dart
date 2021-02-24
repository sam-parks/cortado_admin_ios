import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:flutter/material.dart';

class InheritedAddInProvider extends InheritedWidget {
  InheritedAddInProvider(this.addIn, {Key key, this.child})
      : super(key: key, child: child);
  final AddIn addIn;
  final Widget child;

  static InheritedAddInProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedAddInProvider>();
  }

  @override
  bool updateShouldNotify(InheritedAddInProvider oldWidget) {
    return addIn != oldWidget.addIn;
  }
}
