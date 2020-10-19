import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/category/category_bloc.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/bloc/menu/menu_event.dart';
import 'package:flutter/material.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({@required this.categoryBloc}) : super(MenuState.loading()) {
    _categoryStateSubscription = categoryBloc.listen((categoryState) {
      print(categoryState);
      if (categoryState is CategoryAdded ||
          categoryState is CategoryRemoved ||
          categoryState is CategoryUpdated) {
        this.add(UpdateMenu(categoryBloc.state.coffeeShop));
      }
    });
  }

  final CategoryBloc categoryBloc;
  StreamSubscription _categoryStateSubscription;

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
    print("close called");
    _categoryStateSubscription.cancel();
    return super.close();
  }
}
