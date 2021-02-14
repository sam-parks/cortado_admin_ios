import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MenuEvent {}

class SetMenu extends MenuEvent {
  final CoffeeShop coffeeShop;

  SetMenu(this.coffeeShop);
}

class UpdateMenu extends MenuEvent {
  final Menu menu;

  UpdateMenu(this.menu);
}
