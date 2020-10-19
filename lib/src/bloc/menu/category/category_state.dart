part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState(this.coffeeShop);
  final CoffeeShop coffeeShop;

  @override
  List<Object> get props => [coffeeShop];
}

class CategoryInitial extends CategoryState {
  CategoryInitial(CoffeeShop coffeeShop) : super(coffeeShop);
}

class CategoryAdded extends CategoryState {
  final CoffeeShop coffeeShop;

  CategoryAdded(this.coffeeShop) : super(coffeeShop);
}

class CategoryRemoved extends CategoryState {
  final CoffeeShop coffeeShop;

  CategoryRemoved(this.coffeeShop) : super(coffeeShop);
}

class CategoryUpdated extends CategoryState {
  final CoffeeShop coffeeShop;

  CategoryUpdated(this.coffeeShop) : super(coffeeShop);
}
