part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {}

class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryAdded extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryRemoved extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryUpdated extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {
  @override
  List<Object> get props => [];
}
