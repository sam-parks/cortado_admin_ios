part of 'food_item_bloc.dart';

abstract class FoodItemEvent extends Equatable {
  const FoodItemEvent();

  @override
  List<Object> get props => [];
}

class InitializeFoodItem extends FoodItemEvent {
  final FoodTemplate foodTemplate;

  InitializeFoodItem(this.foodTemplate);
}

class ChangeName extends FoodItemEvent {
  final String name;

  ChangeName(this.name);
}

class ChangeDescription extends FoodItemEvent {
  final String description;

  ChangeDescription(this.description);
}

class ChangePrice extends FoodItemEvent {
  final String price;

  ChangePrice(this.price);
}
