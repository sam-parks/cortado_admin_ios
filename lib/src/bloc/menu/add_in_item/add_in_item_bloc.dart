import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:equatable/equatable.dart';

part 'add_in_item_event.dart';
part 'add_in_item_state.dart';

class AddInItemBloc extends Bloc<AddInItemEvent, AddInItemState> {
  AddInItemBloc() : super(AddInItemState());

  @override
  Stream<AddInItemState> mapEventToState(
    AddInItemEvent event,
  ) async* {
    if (event is InitializeItem) {
     yield state.copyWith(addIn: event.addIn);
    } else if (event is ChangeName) {
      yield state.copyWith(name: event.name);
    } else if (event is ChangeDescription) {
      yield state.copyWith(description: event.description);
    } else if (event is ChangePrice) {
      yield state.copyWith(name: event.price);
    }
  }
}
