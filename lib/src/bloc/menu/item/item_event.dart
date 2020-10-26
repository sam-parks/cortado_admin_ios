part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends ItemEvent {
  final CategoryType type;
  final String categoryId;
  final Item item;
  final CoffeeShop coffeeShop;

  AddItem(
    this.type,
    this.categoryId,
    this.item,
    this.coffeeShop,
  );
}

class UpdateItem extends ItemEvent {
  final CategoryType type;
  final String categoryId;
  final Item item;
  final CoffeeShop coffeeShop;

  UpdateItem(this.type, this.categoryId, this.item, this.coffeeShop);
}

class RemoveItem extends ItemEvent {
  final CategoryType type;
  final String categoryId;
  final Item item;
  final CoffeeShop coffeeShop;

  RemoveItem(this.type, this.categoryId, this.item, this.coffeeShop);
}
