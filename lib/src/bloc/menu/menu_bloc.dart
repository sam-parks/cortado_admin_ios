import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  CoffeeShopService get _coffeeShopService => locator.get();

  MenuBloc() : super(null);

  @override
  Stream<MenuState> mapEventToState(
    MenuEvent event,
  ) async* {
    if (event is UpdateMenu) {
      await _coffeeShopService.updateCoffeeShop(event.coffeeShop);
    }
    if (event is RemoveCategory) {
      await _coffeeShopService.updateCoffeeShop(event.coffeeShop);
    }
  }
}
