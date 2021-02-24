import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drink_item_event.dart';
part 'drink_item_state.dart';

class DrinkItemBloc extends Bloc<DrinkItemEvent, DrinkItemState> {
  DrinkItemBloc() : super(DrinkItemInitial());

  @override
  Stream<DrinkItemState> mapEventToState(
    DrinkItemEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
