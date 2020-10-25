import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'coffee_shop_event.dart';
part 'coffee_shop_state.dart';

class CoffeeShopBloc extends Bloc<CoffeeShopEvent, CoffeeShopState> {
  final MenuBloc menuBloc;
  StreamSubscription _menuStateSubscription;

  CoffeeShopBloc({@required this.menuBloc})
      : super(CoffeeShopState.uninitialized()) {
    _menuStateSubscription = menuBloc.listen((menuState) {
      if (menuState.status == MenuStatus.updated) {
        print("updating coffee shop from menu");
        this.add(UpdateCoffeeShop(state.coffeeShop));
      }
    });
  }

  CoffeeShopService get _coffeeShopService => locator.get();

  @override
  Stream<CoffeeShopState> mapEventToState(
    CoffeeShopEvent event,
  ) async* {
    if (event is InitializeCoffeeShop) {
      yield CoffeeShopState.loading();
      CoffeeShop coffeeShop = await _coffeeShopService.init(event.id);
      menuBloc.add(SetMenu(
          coffeeShop, coffeeShop.food, coffeeShop.drinks, coffeeShop.addIns));
      yield CoffeeShopState.initialized(coffeeShop);
    }

    if (event is UpdateCoffeeShop) {
      CoffeeShop coffeeShop = event.coffeeShop.copy(event.coffeeShop);

      yield CoffeeShopState.initialized(coffeeShop);
    }

    if (event is UninitializeCoffeeShop) {
      yield CoffeeShopState.uninitialized();
    }
  }

  @override
  Future<void> close() {
    _menuStateSubscription.cancel();
    return super.close();
  }
}
