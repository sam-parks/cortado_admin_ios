import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());
  MenuService get _menuService => locator.get();
  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is AddCategory) {
      yield CategoryLoading();
      await _menuService.addCategory(
          event.coffeeShopId, event.type, event.category);
      yield CategoryAdded();
    }
    if (event is RemoveCategory) {
      yield CategoryLoading();
      await _menuService.removeCategory(
          event.coffeeShopId, event.type, event.category);
      yield CategoryUpdated();
    }

    if (event is UpdateCategory) {
      yield CategoryLoading();
      await _menuService.updateCategory(
          event.coffeeShopId, event.type, event.category);
      yield CategoryUpdated();
    }
  }
}
