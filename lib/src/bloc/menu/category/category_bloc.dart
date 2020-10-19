import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial(null));

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is AddCategory) {
      CoffeeShop updatedCoffeeShop =
          addCategoryToCoffeeShop(event.type, event.category, event.coffeeShop);

      yield CategoryAdded(updatedCoffeeShop);
    }
    if (event is RemoveCategory) {
      CoffeeShop updatedCoffeeShop = removeCategoryFromCoffeeShop(
          event.type, event.category, event.coffeeShop);
      yield CategoryRemoved(updatedCoffeeShop);
    }

    if (event is UpdateCategory) {
      CoffeeShop updatedCoffeeShop = updateCategoryForCoffeeShop(
          event.type, event.category, event.coffeeShop);
      yield CategoryUpdated(updatedCoffeeShop);
    }
  }

  CoffeeShop addCategoryToCoffeeShop(
      CategoryType categoryType, Category category, CoffeeShop coffeeShop) {
    switch (categoryType) {
      case CategoryType.drink:
        coffeeShop.drinks.add(category);
        break;
      case CategoryType.food:
        coffeeShop.food.add(category);
        break;
      case CategoryType.addIn:
        coffeeShop.addIns.add(category);
        break;
    }
    return coffeeShop.copy(coffeeShop);
  }

  CoffeeShop removeCategoryFromCoffeeShop(
      CategoryType categoryType, Category category, CoffeeShop coffeeShop) {
    switch (categoryType) {
      case CategoryType.drink:
        coffeeShop.drinks.remove(category);
        break;
      case CategoryType.food:
        coffeeShop.food.remove(category);
        break;
      case CategoryType.addIn:
        coffeeShop.addIns.remove(category);
        break;
    }
    return coffeeShop.copy(coffeeShop);
  }

  CoffeeShop updateCategoryForCoffeeShop(CategoryType categoryType,
      Category updatedCategory, CoffeeShop coffeeShop) {
    switch (categoryType) {
      case CategoryType.drink:
        coffeeShop.drinks.forEach((category) {
          if (category.id == updatedCategory.id) {
            coffeeShop.drinks.remove(category);
            coffeeShop.drinks.add(updatedCategory);
          }
        });
        break;
      case CategoryType.food:
        coffeeShop.food.forEach((category) {
          if (category.id == updatedCategory.id) {
            coffeeShop.food.remove(category);
            coffeeShop.food.add(updatedCategory);
          }
        });
        break;
      case CategoryType.addIn:
        coffeeShop.addIns.forEach((category) {
          if (category.id == updatedCategory.id) {
            coffeeShop.addIns.remove(category);
            coffeeShop.addIns.add(updatedCategory);
          }
        });
        break;
    }
    return coffeeShop.copy(coffeeShop);
  }
}
