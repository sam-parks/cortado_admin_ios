import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:equatable/equatable.dart';

part 'food_item_event.dart';
part 'food_item_state.dart';

class FoodItemBloc extends Bloc<FoodItemEvent, FoodItemState> {
  FoodItemBloc() : super(FoodItemState());

  @override
  Stream<FoodItemState> mapEventToState(
    FoodItemEvent event,
  ) async* {
    if (event is InitializeItem) {
      yield state.copyWith(foodTemplate: event.foodTemplate);
    } else if (event is ChangeName) {
      FoodTemplate foodTemplate = state.foodTemplate.copyWith(name: event.name);
      yield state.copyWith(name: event.name, foodTemplate: foodTemplate);
    } else if (event is ChangeDescription) {
      FoodTemplate foodTemplate =
          state.foodTemplate.copyWith(description: event.description);
      yield state.copyWith(
          description: event.description, foodTemplate: foodTemplate);
    } else if (event is ChangePrice) {
      FoodTemplate foodTemplate =
          state.foodTemplate.copyWith(price: event.price);
      yield state.copyWith(name: event.price, foodTemplate: foodTemplate);
    }
  }
}
