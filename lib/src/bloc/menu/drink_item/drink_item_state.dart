part of 'drink_item_bloc.dart';

abstract class DrinkItemState extends Equatable {
  const DrinkItemState();
  
  @override
  List<Object> get props => [];
}

class DrinkItemInitial extends DrinkItemState {}
