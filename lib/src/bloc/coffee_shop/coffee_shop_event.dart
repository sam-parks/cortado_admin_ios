part of 'coffee_shop_bloc.dart';

abstract class CoffeeShopEvent extends Equatable {
  const CoffeeShopEvent();

  @override
  List<Object> get props => [];
}

class InitializeCoffeeShop extends CoffeeShopEvent {
  final String id;

  InitializeCoffeeShop(this.id);
}

class UpdateCoffeeShop extends CoffeeShopEvent {
  final CoffeeShop coffeeShop;

  UpdateCoffeeShop(this.coffeeShop);
}
