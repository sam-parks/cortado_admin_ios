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
    if (event is InitializeAddInItem) {
      yield state.copyWith(addIn: event.addIn);
    } else if (event is ChangeName) {
      AddIn addIn = state.addIn.copyWith(name: event.name);
      yield state.copyWith(addIn: addIn);
    } else if (event is ChangePrice) {
      AddIn addIn = state.addIn.copyWith(price: event.price);
      yield state.copyWith(addIn: addIn);
    }
  }
}
