import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/category/category_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/item/item_bloc.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/bloc/menu/menu_event.dart';
import 'package:flutter/material.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({@required this.categoryBloc, @required this.itemBloc})
      : super(MenuState.loading()) {
    _categoryStateSubscription = categoryBloc.listen((categoryState) {
      this.add(UpdateMenu(categoryBloc.state.coffeeShop));
    });

    _itemStateSubscription = itemBloc.listen((categoryState) {
      this.add(UpdateMenu(itemBloc.state.coffeeShop));
    });
  }

  final CategoryBloc categoryBloc;
  StreamSubscription _categoryStateSubscription;

  final ItemBloc itemBloc;
  StreamSubscription _itemStateSubscription;

  CoffeeShopService get _coffeeShopService => locator.get();

  @override
  Stream<MenuState> mapEventToState(
    MenuEvent event,
  ) async* {
    if (event is SetMenu) {
      yield MenuState.initialized(event.coffeeShop);
    }

    if (event is UpdateMenu) {
      yield MenuState.loading();
      _coffeeShopService.updateCoffeeShop(event.coffeeShop);
      yield MenuState.updated(event.coffeeShop);
    }
  }

  @override
  Future<void> close() {
    _categoryStateSubscription.cancel();
    _itemStateSubscription.cancel();
    return super.close();
  }
}
