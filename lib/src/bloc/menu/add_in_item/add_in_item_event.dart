part of 'add_in_item_bloc.dart';

abstract class AddInItemEvent extends Equatable {
  const AddInItemEvent();

  @override
  List<Object> get props => [];
}

class InitializeItem extends AddInItemEvent {
  final AddIn addIn;

  InitializeItem(this.addIn);
}

class ChangeName extends AddInItemEvent {
  final String name;

  ChangeName(this.name);
}

class ChangeDescription extends AddInItemEvent {
  final String description;

  ChangeDescription(this.description);
}

class ChangePrice extends AddInItemEvent {
  final String price;

  ChangePrice(this.price);
}
