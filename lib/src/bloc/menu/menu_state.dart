import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:flutter/material.dart';

enum MenuStatus { initialized, loading, updated }

@immutable
class MenuState {
  const MenuState._({this.coffeeShop = CoffeeShop.empty, this.status});

  const MenuState.loading() : this._(status: MenuStatus.loading);

  const MenuState.initialized(coffeeShop)
      : this._(coffeeShop: coffeeShop, status: MenuStatus.initialized);

  const MenuState.updated(coffeeShop)
      : this._(coffeeShop: coffeeShop, status: MenuStatus.updated);

  final CoffeeShop coffeeShop;
  final MenuStatus status;
}
