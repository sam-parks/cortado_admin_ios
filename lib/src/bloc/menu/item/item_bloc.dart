import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial());

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
