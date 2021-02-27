part of 'add_in_item_bloc.dart';

class AddInItemState extends Equatable {
  const AddInItemState({this.addIn});

  final AddIn addIn;

  AddInItemState copyWith({
    final AddIn addIn,
  }) {
    return AddInItemState(
      addIn: addIn ?? this.addIn,
    );
  }

  @override
  List<Object> get props => [addIn];
}
