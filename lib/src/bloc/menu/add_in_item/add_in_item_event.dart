part of 'add_in_item_bloc.dart';

abstract class AddInItemEvent extends Equatable {
  const AddInItemEvent();

  @override
  List<Object> get props => [];
}

class InitializeAddInItem extends AddInItemEvent {
  final AddIn addIn;

  InitializeAddInItem(this.addIn);
}

class ChangeName extends AddInItemEvent {
  final String name;

  ChangeName(this.name);
}

class ChangePrice extends AddInItemEvent {
  final String price;

  ChangePrice(this.price);
}
