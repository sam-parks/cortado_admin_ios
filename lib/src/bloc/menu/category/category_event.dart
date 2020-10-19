part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class AddCategory extends CategoryEvent {
  final CategoryType type;
  final Category category;
  final CoffeeShop coffeeShop;

  AddCategory(this.type, this.category, this.coffeeShop);
}

class RemoveCategory extends CategoryEvent {
  final CategoryType type;
  final Category category;
  final CoffeeShop coffeeShop;

  RemoveCategory(this.type, this.category, this.coffeeShop);
}
