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
  final Menu menu;
  final String coffeeShopId;

  AddItem(
    this.type,
    this.categoryId,
    this.item,
    this.menu,
    this.coffeeShopId,
  );
}

class UpdateItem extends ItemEvent {
  final CategoryType type;
  final String categoryId;
  final Item item;
  final Menu menu;
  final String coffeeShopId;

  UpdateItem(
      this.type, this.categoryId, this.item, this.menu, this.coffeeShopId);
}

class RemoveItem extends ItemEvent {
  final CategoryType type;
  final String categoryId;
  final Item item;
  final Menu menu;
  final String coffeeShopId;

  RemoveItem(
      this.type, this.categoryId, this.item, this.menu, this.coffeeShopId);
}
