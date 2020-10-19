import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is AddCategory) {
      CoffeeShop updatedCoffeeShop =
          addCategoryToCoffeeShop(event.type, event.category, event.coffeeShop);

      yield CategoriesUpdated(updatedCoffeeShop);
    }
    if (event is RemoveCategory) {
      CoffeeShop updatedCoffeeShop = removeCategoryFromCoffeeShop(
          event.type, event.category, event.coffeeShop);
      yield CategoriesUpdated(updatedCoffeeShop);
    }
  }

  // ignore: missing_return
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
    return coffeeShop;
  }

  // ignore: missing_return
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
    return coffeeShop;
  }
}
