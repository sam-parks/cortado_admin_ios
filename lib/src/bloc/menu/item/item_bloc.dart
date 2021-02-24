import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:equatable/equatable.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial());
  MenuService get _menuService => locator.get();

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is AddItem) {
      yield ItemLoading();
      _menuService.addItemInCategory(
          event.coffeeShopId, event.type, event.categoryId, event.item);

      yield ItemAdded();
    }
    if (event is RemoveItem) {
      yield ItemLoading();
      await _menuService.removeItemInCategory(
          event.coffeeShopId, event.type, event.categoryId, event.item);
      yield ItemRemoved();
    }

    if (event is UpdateItem) {
      yield ItemLoading();
      _menuService.updateItemInCategory(
          event.coffeeShopId, event.type, event.categoryId, event.item);
      yield ItemUpdated();
    }
  }
}
