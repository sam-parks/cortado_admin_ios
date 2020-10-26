part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState(this.coffeeShop);

  final CoffeeShop coffeeShop;

  @override
  List<Object> get props => [coffeeShop];
}

class ItemInitial extends ItemState {
  ItemInitial() : super(null);
}

class ItemAdded extends ItemState {
  final CoffeeShop coffeeShop;

  ItemAdded(this.coffeeShop) : super(coffeeShop);
}

class ItemRemoved extends ItemState {
  final CoffeeShop coffeeShop;

  ItemRemoved(this.coffeeShop) : super(coffeeShop);
}

class ItemUpdated extends ItemState {
  final CoffeeShop coffeeShop;

  ItemUpdated(this.coffeeShop) : super(coffeeShop);
}
