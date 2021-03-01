part of 'drink_item_bloc.dart';

abstract class DrinkItemEvent extends Equatable {
  const DrinkItemEvent();

  @override
  List<Object> get props => [];
}

class InitializeDrinkItem extends DrinkItemEvent {
  final DrinkTemplate drinkTemplate;

  InitializeDrinkItem(this.drinkTemplate);
}

class ChangeName extends DrinkItemEvent {
  final String name;

  ChangeName(this.name);
}

class ChangeDescription extends DrinkItemEvent {
  final String description;

  ChangeDescription(this.description);
}

class AddPriceToSizePriceMap extends DrinkItemEvent {
  final SizeInOunces size;

  AddPriceToSizePriceMap(this.size);
}

class RemovePriceFromSizePriceMap extends DrinkItemEvent {
  final SizeInOunces size;

  RemovePriceFromSizePriceMap(this.size);
}

class ChangePriceForSize extends DrinkItemEvent {
  final SizeInOunces size;
  final String price;

  ChangePriceForSize(this.size, this.price);
}

class ChangeServeIced extends DrinkItemEvent {
  final bool serveIced;

  ChangeServeIced(this.serveIced);
}

class ChangeRedeemableSize extends DrinkItemEvent {
  final SizeInOunces redeemableSize;

  ChangeRedeemableSize(this.redeemableSize);
  @override
  List<Object> get props => [redeemableSize];
}

class ChangeRedeemableType extends DrinkItemEvent {
  final RedeemableType type;
  final SizeInOunces size;

  ChangeRedeemableType(this.type, this.size);
  @override
  List<Object> get props => [type, size];
}

class AddToRequiredAddIns extends DrinkItemEvent {
  final String addInId;

  AddToRequiredAddIns(this.addInId);
}

class RemoveFromRequiredAddIns extends DrinkItemEvent {
  final String addInId;

  RemoveFromRequiredAddIns(this.addInId);
}

class AddToAvailableAddIns extends DrinkItemEvent {
  final String addInId;

  AddToAvailableAddIns(this.addInId);
}

class RemoveFromAvailableAddIns extends DrinkItemEvent {
  final String addInId;

  RemoveFromAvailableAddIns(this.addInId);
}
