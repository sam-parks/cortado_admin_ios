import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/menu/bloc.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';

import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/bloc/menu/menu_event.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState.loading()) {
    _categorySubscription = _menuService.categories.listen((categoryTuple) {
      switch (categoryTuple.item1) {
        case CategoryType.drink:
          Menu updatedMenu =
              state.menu.copyWith(drinkTemplates: categoryTuple.item2);
          this.add(UpdateMenu(updatedMenu));
          break;
        case CategoryType.food:
          Menu updatedMenu =
              state.menu.copyWith(foodTemplates: categoryTuple.item2);
          this.add(UpdateMenu(updatedMenu));
          break;
        case CategoryType.addIn:
          Menu updatedMenu = state.menu.copyWith(addIns: categoryTuple.item2);
          this.add(UpdateMenu(updatedMenu));
          break;
      }
    });

    _itemSubscription = _menuService.items.listen((categoryTuple) {
      switch (categoryTuple.item1) {
        case CategoryType.drink:
          List<Category> drinkTemplates =
              _updateSingularCategory(CategoryType.drink, categoryTuple.item2);

          Menu updatedMenu =
              state.menu.copyWith(drinkTemplates: drinkTemplates);
          this.add(UpdateMenu(updatedMenu));
          break;
        case CategoryType.food:
          List<Category> foodTemplates =
              _updateSingularCategory(CategoryType.food, categoryTuple.item2);

          Menu updatedMenu = state.menu.copyWith(foodTemplates: foodTemplates);
          this.add(UpdateMenu(updatedMenu));
          break;
        case CategoryType.addIn:
          List<Category> addIns =
              _updateSingularCategory(CategoryType.addIn, categoryTuple.item2);

          Menu updatedMenu = state.menu.copyWith(addIns: addIns);
          this.add(UpdateMenu(updatedMenu));
          break;
      }
    });

    _discountSubscription = _menuService.discounts.listen((discounts) {
      Menu updatedMenu = state.menu.copyWith(discounts: discounts);
      this.add(UpdateMenu(updatedMenu));
    });
  }
  StreamSubscription _categorySubscription;
  StreamSubscription _itemSubscription;
  StreamSubscription _discountSubscription;

  MenuService get _menuService => locator.get();

  @override
  Stream<MenuState> mapEventToState(
    MenuEvent event,
  ) async* {
    if (event is SetMenu) {
      yield MenuState.loading();
      String coffeeShopId = event.coffeeShop.id;
      _menuService.getCategories(coffeeShopId);
      _menuService.getFoodItems(coffeeShopId);
      _menuService.getDrinkItems(coffeeShopId);
      _menuService.getAddInItems(coffeeShopId);
      _menuService.getDiscounts(coffeeShopId);
    }

    if (event is UpdateMenu) {
      yield MenuState.initialized(event.menu);
    }
  }

  // ignore: missing_return
  List<Category> _updateSingularCategory(CategoryType type, Category category) {
    Menu menu = state.menu;
    List<String> categoryIds = [];
    List<Category> updatedCategories;

    switch (type) {
      case CategoryType.drink:
        if (menu.drinkTemplates.isEmpty) {
          updatedCategories = List.from(menu.drinkTemplates)..add(category);
          return updatedCategories;
        }
        categoryIds = menu.drinkTemplates.map((e) => e.id).toList();
        if (categoryIds.contains(category.id)) {
          updatedCategories = List.from(menu.drinkTemplates)
            ..removeWhere((element) => element.id == category.id)
            ..add(category);
        } else {
          updatedCategories = List.from(menu.drinkTemplates)..add(category);
        }
        return updatedCategories;
        break;
      case CategoryType.food:
        if (menu.foodTemplates.isEmpty) {
          updatedCategories = List.from(menu.foodTemplates)..add(category);
          return updatedCategories;
        }
        categoryIds = menu.foodTemplates.map((e) => e.id).toList();
        if (categoryIds.contains(category.id)) {
          updatedCategories = List.from(menu.foodTemplates)
            ..removeWhere((element) => element.id == category.id)
            ..add(category);
        } else {
          updatedCategories = List.from(menu.foodTemplates)..add(category);
        }
        return updatedCategories;
        break;
      case CategoryType.addIn:
        if (menu.addIns.isEmpty) {
          updatedCategories = List.from(menu.addIns)..add(category);
          return updatedCategories;
        }
        categoryIds = menu.addIns.map((e) => e.id).toList();
        if (categoryIds.contains(category.id)) {
          updatedCategories = List.from(menu.addIns)
            ..removeWhere((element) => element.id == category.id)
            ..add(category);
        } else {
          updatedCategories = List.from(menu.addIns)..add(category);
        }
        return updatedCategories;
        break;
    }
  }

  @override
  Future<void> close() {
    _categorySubscription.cancel();
    _itemSubscription.cancel();
    _discountSubscription.cancel();
    return super.close();
  }
}
