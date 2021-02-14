part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class AddCategory extends CategoryEvent {
  final CategoryType type;
  final Category category;
  final Menu menu;
  final String coffeeShopId;

  AddCategory(this.type, this.category, this.menu, this.coffeeShopId);
}

class UpdateCategory extends CategoryEvent {
  final CategoryType type;
  final Category category;
  final Menu menu;
  final String coffeeShopId;

  UpdateCategory(this.type, this.category, this.menu, this.coffeeShopId);
}

class RemoveCategory extends CategoryEvent {
  final CategoryType type;
  final Category category;
  final Menu menu;
  final String coffeeShopId;

  RemoveCategory(this.type, this.category, this.menu, this.coffeeShopId);
}
