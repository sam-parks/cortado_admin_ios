part of 'food_item_bloc.dart';

class FoodItemState extends Equatable {
  const FoodItemState(
      {this.foodTemplate, this.name, this.description, this.price});

  final FoodTemplate foodTemplate;
  final String name;
  final String description;
  final String price;

  FoodItemState copyWith(
      {final FoodTemplate foodTemplate,
      final String name,
      final String description,
      final String price}) {
    return FoodItemState(
        foodTemplate: foodTemplate ?? this.foodTemplate,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price);
  }

  @override
  List<Object> get props => [name, description, price];
}
