part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState(this.menu, this.coffeeShopId);
  final String coffeeShopId;
  final Menu menu;

  @override
  List<Object> get props => [menu, coffeeShopId];
}

class CategoryInitial extends CategoryState {
  CategoryInitial(Menu menu, String id) : super(menu, id);
}

class CategoryAdded extends CategoryState {
  final String coffeeShopId;
  final Menu menu;

  CategoryAdded(this.menu, this.coffeeShopId) : super(menu, coffeeShopId);
}

class CategoryRemoved extends CategoryState {
  final String coffeeShopId;
  final Menu menu;

  CategoryRemoved(this.menu, this.coffeeShopId) : super(menu, coffeeShopId);
}

class CategoryUpdated extends CategoryState {
  final String coffeeShopId;
  final Menu menu;

  CategoryUpdated(this.menu, this.coffeeShopId) : super(menu, coffeeShopId);
}
