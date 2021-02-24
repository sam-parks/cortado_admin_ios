part of 'add_in_item_bloc.dart';

class AddInItemState extends Equatable {
  const AddInItemState({this.addIn, this.name, this.description, this.price});

  final AddIn addIn;
  final String name;
  final String description;
  final String price;

  AddInItemState copyWith(
      {final AddIn addIn,
      final String name,
      final String description,
      final String price}) {
    return AddInItemState(
        addIn: addIn ?? this.addIn,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price);
  }

  @override
  List<Object> get props => [addIn, name, description, price];
}
