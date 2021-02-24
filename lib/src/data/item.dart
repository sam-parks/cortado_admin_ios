import 'package:cortado_admin_ios/src/data/item_template.dart';
import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:equatable/equatable.dart';

abstract class Item {
  String id;
  String name;
  String price;
  int quantity;
  String size;
  String orderId;
  ItemTemplate itemTemplate;

  Item(this.id, this.itemTemplate, this.orderId, this.name, this.price,
      this.size, this.quantity);
}

class Drink extends Item with EquatableMixin {
  final String id;
  final String name;
  DrinkTemplate drinkTemplate;
  String price;
  RedeemableType redeemableType;
  SizeInOunces redeemableSize;
  String orderId;
  String size;
  List<AddIn> addIns;
  List<dynamic> requiredAddInsSelected;
  int quantity;
  bool servedIced;

  Drink(
      {this.id,
      this.redeemableSize,
      this.drinkTemplate,
      this.orderId,
      this.name,
      this.price,
      this.servedIced,
      this.size,
      this.redeemableType,
      this.addIns,
      this.requiredAddInsSelected,
      this.quantity})
      : super(id, drinkTemplate, orderId, name, price, size, quantity);

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'redeemableType': redeemableType.statusToString(),
      'redeemableSize': redeemableSize.sizeToString(),
      'servedIced': servedIced,
      'size': size,
      'quantity': quantity,
      'addIns': _addinsToJson(addIns),
      'requiredAddInsSelected': requiredAddInsSelected
    };
  }

  List<Map> _addinsToJson(List<AddIn> addIns) {
    return List.generate(addIns.length, (index) => addIns[index].toJson());
  }

  @override
  List<Object> get props =>
      [id, name, price, redeemableType, size, quantity, addIns];
}

class Food extends Item with EquatableMixin {
  final String id;
  final String name;
  final String orderId;
  FoodTemplate foodTemplate;
  String price;
  String notes;
  int quantity;

  Food({
    this.id,
    this.orderId,
    this.foodTemplate,
    this.name,
    this.price,
    this.notes,
    this.quantity,
  }) : super(id, foodTemplate, orderId, name, price, '', quantity);

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'notes': notes
    };
  }

  @override
  List<Object> get props => [id, orderId, name, price, notes, quantity];
}
