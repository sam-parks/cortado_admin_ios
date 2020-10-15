import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MenuEvent {}

class UpdateMenu extends MenuEvent {
  final CoffeeShop coffeeShop;

  UpdateMenu(this.coffeeShop);
}

class RemoveCategory extends MenuEvent {
  final CoffeeShop coffeeShop;

  RemoveCategory(this.coffeeShop);
}
