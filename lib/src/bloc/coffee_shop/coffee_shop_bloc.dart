import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';

import 'package:equatable/equatable.dart';

part 'coffee_shop_event.dart';
part 'coffee_shop_state.dart';

class CoffeeShopBloc extends Bloc<CoffeeShopEvent, CoffeeShopState> {
  CoffeeShopBloc() : super(CoffeeShopState.uninitialized());

  CoffeeShopService get _coffeeShopService => locator.get();

  @override
  Stream<CoffeeShopState> mapEventToState(
    CoffeeShopEvent event,
  ) async* {
    if (event is InitializeCoffeeShop) {
      yield CoffeeShopState.loading();
      CoffeeShop coffeeShop = await _coffeeShopService.init(event.id);
      yield CoffeeShopState.initialized(coffeeShop);
    }

    if (event is UpdateCoffeeShop) {
      yield CoffeeShopState.initialized(event.coffeeShop);
    }
  }
}
