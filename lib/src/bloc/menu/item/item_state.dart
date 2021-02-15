part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemState {}

class ItemInitial extends ItemState {}

class ItemAdded extends ItemState {}

class ItemRemoved extends ItemState {}

class ItemUpdated extends ItemState {}
