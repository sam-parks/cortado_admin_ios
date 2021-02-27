part of 'food_item_bloc.dart';

class FoodItemState extends Equatable {
  const FoodItemState({
    this.foodTemplate,
  });

  final FoodTemplate foodTemplate;

  FoodItemState copyWith({final FoodTemplate foodTemplate}) {
    return FoodItemState(
      foodTemplate: foodTemplate ?? this.foodTemplate,
    );
  }

  @override
  List<Object> get props => [foodTemplate];
}
