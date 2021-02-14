import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:equatable/equatable.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial());

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is AddItem) {
      Menu updatedMenu = addItemToCoffeeShop(
          event.type, event.categoryId, event.item, event.menu);

      yield ItemAdded(updatedMenu, event.coffeeShopId);
    }
    if (event is RemoveItem) {
      Menu updatedMenu = removeItemFromCoffeeShop(
          event.type, event.categoryId, event.item, event.menu);
      yield ItemRemoved(updatedMenu, event.coffeeShopId);
    }

    if (event is UpdateItem) {
      Menu updatedMenu = updateItemForCoffeeShop(
          event.type, event.categoryId, event.item, event.menu);
      yield ItemUpdated(updatedMenu, event.coffeeShopId);
    }
  }

  Menu addItemToCoffeeShop(
      CategoryType categoryType, String categoryId, Item itemToAdd, Menu menu) {
    switch (categoryType) {
      case CategoryType.drink:
        menu.drinkTemplates.forEach((category) {
          if (category.id == categoryId) {
            category.items.add(itemToAdd);
          }
        });
        break;
      case CategoryType.addIn:
        menu.addIns.forEach((category) {
          if (category.id == categoryId) {
            category.items.add(itemToAdd);
          }
        });
        break;
      case CategoryType.food:
        menu.foodTemplates.forEach((category) {
          if (category.id == categoryId) {
            category.items.add(itemToAdd);
          }
        });
        break;
    }

    return menu.copy(menu);
  }

  Menu removeItemFromCoffeeShop(CategoryType categoryType, String categoryId,
      Item itemToRemove, Menu menu) {
    switch (categoryType) {
      case CategoryType.addIn:
        menu.addIns.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == itemToRemove.id);
          }
        });
        break;
      case CategoryType.drink:
        menu.drinkTemplates.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == itemToRemove.id);
          }
        });
        break;
      case CategoryType.food:
        menu.foodTemplates.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == itemToRemove.id);
          }
        });
        break;
    }

    return menu.copy(menu);
  }

  Menu updateItemForCoffeeShop(CategoryType categoryType, String categoryId,
      Item updatedItem, Menu menu) {
    switch (categoryType) {
      case CategoryType.drink:
        menu.drinkTemplates.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == updatedItem.id);
            category.items.add(updatedItem);
          }
        });
        break;
      case CategoryType.addIn:
        menu.addIns.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == updatedItem.id);
            category.items.add(updatedItem);
          }
        });
        break;
      case CategoryType.food:
        menu.foodTemplates.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == updatedItem.id);
            category.items.add(updatedItem);
          }
        });
        break;
    }

    return menu.copy(menu);
  }
}
