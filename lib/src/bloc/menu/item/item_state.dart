part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState(this.menu, this.coffeeShopId);
  final String coffeeShopId;
  final Menu menu;

  @override
  List<Object> get props => [menu, coffeeShopId];
}

class ItemInitial extends ItemState {
  ItemInitial() : super(null, null);
}

class ItemAdded extends ItemState {
  final Menu menu;
  final String coffeeShopId;
  ItemAdded(this.menu, this.coffeeShopId) : super(menu, coffeeShopId);
}

class ItemRemoved extends ItemState {
  final Menu menu;
  final String coffeeShopId;
  ItemRemoved(this.menu, this.coffeeShopId) : super(menu, coffeeShopId);
}

class ItemUpdated extends ItemState {
  final Menu menu;
  final String coffeeShopId;
  ItemUpdated(this.menu, this.coffeeShopId) : super(menu, coffeeShopId);
}
