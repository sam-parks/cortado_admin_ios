import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial(null, null));

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is AddCategory) {
      Menu updatedMenu =
          addCategoryToCoffeeShop(event.type, event.category, event.menu);

      yield CategoryAdded(updatedMenu, event.coffeeShopId);
    }
    if (event is RemoveCategory) {
      Menu updatedMenu =
          removeCategoryFromCoffeeShop(event.type, event.category, event.menu);
      yield CategoryRemoved(updatedMenu, event.coffeeShopId);
    }

    if (event is UpdateCategory) {
      Menu updatedMenu =
          updateCategoryForCoffeeShop(event.type, event.category, event.menu);
      yield CategoryUpdated(updatedMenu, event.coffeeShopId);
    }
  }

  Menu addCategoryToCoffeeShop(
      CategoryType categoryType, Category category, Menu menu) {
    switch (categoryType) {
      case CategoryType.drink:
        menu.drinkTemplates.add(category);
        break;
      case CategoryType.food:
        menu.foodTemplates.add(category);
        break;
      case CategoryType.addIn:
        menu.addIns.add(category);
        break;
    }
    return menu.copy(menu);
  }

  Menu removeCategoryFromCoffeeShop(
      CategoryType categoryType, Category category, Menu menu) {
    switch (categoryType) {
      case CategoryType.drink:
        menu.drinkTemplates.remove(category);
        break;
      case CategoryType.food:
        menu.foodTemplates.remove(category);
        break;
      case CategoryType.addIn:
        menu.addIns.remove(category);
        menu.drinkTemplates.forEach((drinkCategory) {
          drinkCategory.items.forEach((item) {
            Drink drink = item;
            if (drink.requiredAddIns.contains(category.id))
              drink.requiredAddIns.remove(category.id);
          });
        });
        break;
    }
    return menu.copy(menu);
  }

  Menu updateCategoryForCoffeeShop(
      CategoryType categoryType, Category updatedCategory, Menu menu) {
    switch (categoryType) {
      case CategoryType.drink:
        menu.drinkTemplates
            .removeWhere((category) => category.id == updatedCategory.id);
        menu.drinkTemplates.add(updatedCategory);
        break;
      case CategoryType.food:
        menu.foodTemplates
            .removeWhere((category) => category.id == updatedCategory.id);
        menu.foodTemplates.add(updatedCategory);
        break;
      case CategoryType.addIn:
        menu.addIns
            .removeWhere((category) => category.id == updatedCategory.id);
        menu.addIns.add(updatedCategory);
        break;
    }
    return menu.copy(menu);
  }
}
