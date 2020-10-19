import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MenuEvent {}

class SetMenu extends MenuEvent {
  final CoffeeShop coffeeShop;
  final List<Category> food;
  final List<Category> drinks;
  final List<Category> addIns;

  SetMenu(this.coffeeShop, this.food, this.drinks, this.addIns);
}

class UpdateMenu extends MenuEvent {
  final CoffeeShop coffeeShop;

  UpdateMenu(this.coffeeShop);
}
