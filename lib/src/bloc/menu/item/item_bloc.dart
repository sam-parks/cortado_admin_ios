import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
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
      CoffeeShop updatedCoffeeShop = updateItemForCoffeeShop(
          event.type, event.categoryId, event.item, event.coffeeShop);

      yield ItemAdded(updatedCoffeeShop);
    }
    if (event is RemoveItem) {
      CoffeeShop updatedCoffeeShop = updateItemForCoffeeShop(
          event.type, event.categoryId, event.item, event.coffeeShop);
      yield ItemRemoved(updatedCoffeeShop);
    }

    if (event is UpdateItem) {
      CoffeeShop updatedCoffeeShop = updateItemForCoffeeShop(
          event.type, event.categoryId, event.item, event.coffeeShop);
      yield ItemUpdated(updatedCoffeeShop);
    }
  }

  CoffeeShop addItemToCoffeeShop(CategoryType categoryType, String categoryId,
      Item itemToAdd, CoffeeShop coffeeShop) {
    switch (categoryType) {
      case CategoryType.drink:
        coffeeShop.drinks.forEach((category) {
          coffeeShop.drinks.forEach((category) {
            if (category.id == categoryId) {
              category.items.add(itemToAdd);
            }
          });
        });
        break;
      case CategoryType.addIn:
        coffeeShop.addIns.forEach((category) {
          if (category.id == categoryId) {
            category.items.add(itemToAdd);
          }
        });
        break;
      case CategoryType.food:
        coffeeShop.food.forEach((category) {
          if (category.id == categoryId) {
            category.items.add(itemToAdd);
          }
        });
        break;
    }

    return coffeeShop.copy(coffeeShop);
  }

  CoffeeShop removeItemFromCoffeeShop(CategoryType categoryType,
      String categoryId, Item itemToRemove, CoffeeShop coffeeShop) {
    switch (categoryType) {
      case CategoryType.addIn:
        coffeeShop.addIns.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == itemToRemove.id);
          }
        });
        break;
      case CategoryType.drink:
        coffeeShop.drinks.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == itemToRemove.id);
          }
        });
        break;
      case CategoryType.food:
        coffeeShop.food.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == itemToRemove.id);
          }
        });
        break;
    }

    return coffeeShop.copy(coffeeShop);
  }

  CoffeeShop updateItemForCoffeeShop(CategoryType categoryType,
      String categoryId, Item updatedItem, CoffeeShop coffeeShop) {
    switch (categoryType) {
      case CategoryType.drink:
        coffeeShop.drinks.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == updatedItem.id);
            category.items.add(updatedItem);
          }
        });
        break;
      case CategoryType.addIn:
        coffeeShop.addIns.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == updatedItem.id);
            category.items.add(updatedItem);
          }
        });
        break;
      case CategoryType.food:
        coffeeShop.food.forEach((category) {
          if (category.id == categoryId) {
            category.items.removeWhere((item) => item.id == updatedItem.id);
            category.items.add(updatedItem);
          }
        });
        break;
    }

    return coffeeShop.copy(coffeeShop);
  }
}
