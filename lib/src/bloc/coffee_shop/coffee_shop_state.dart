part of 'coffee_shop_bloc.dart';

enum CoffeeShopStatus { initialized, uninitialized, loading, error }

class CoffeeShopState extends Equatable {
  const CoffeeShopState._(
      {this.status = CoffeeShopStatus.uninitialized,
      this.coffeeShop = CoffeeShop.empty,
      this.error = ''});

  const CoffeeShopState.loading() : this._(status: CoffeeShopStatus.loading);

  const CoffeeShopState.initialized(CoffeeShop coffeeShop)
      : this._(status: CoffeeShopStatus.initialized, coffeeShop: coffeeShop);

  const CoffeeShopState.uninitialized()
      : this._(status: CoffeeShopStatus.uninitialized);

  const CoffeeShopState.error(error)
      : this._(status: CoffeeShopStatus.error, error: error);

  final CoffeeShopStatus status;
  final CoffeeShop coffeeShop;
  final String error;

  @override
  List<Object> get props => [status, coffeeShop, error];
}
