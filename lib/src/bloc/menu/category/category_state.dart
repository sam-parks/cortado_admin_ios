part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoriesUpdated extends CategoryState {
  final CoffeeShop coffeeShop;

  CategoriesUpdated(this.coffeeShop);
}
