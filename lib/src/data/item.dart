import 'package:cortado_admin_ios/src/data/coffee_shop.dart';

abstract class Item {
  String id;
  String name;
  String description;
  bool soldOut;
}

class Drink extends Item {
  String id;
  String name;
  String description;
  int quantity;
  RedeemableType redeemableType;
  SizeInOunces redeemableSize;
  Map<String, dynamic> sizePriceMap;
  List<AddIn> addIns;
  List<dynamic> requiredAddIns;
  String size;
  bool servedIced;
  bool soldOut;

  Drink(
      {this.id,
      this.name,
      this.size,
      this.quantity,
      this.sizePriceMap,
      this.addIns,
      this.soldOut,
      this.requiredAddIns,
      this.servedIced,
      this.redeemableSize,
      this.redeemableType,
      this.description});

  toJson() {
    return {
      'id': id,
      'name': name,
      'sizePriceMap': sizePriceMap ?? [],
      'description': description,
      'size': size,
      'quantity': quantity,
      'soldOut': soldOut ?? false,
      'servedIced': servedIced,
      'redeemableSize': redeemableSize.statusToString(),
      'redeemableType': redeemableType.statusToString(),
      'addIns': addIns != null ? _addinsToJson(addIns) : null,
      'requiredAddIns': requiredAddIns
    };
  }

  Drink copyWith(
      {String id,
      String name,
      String description,
      int quantity,
      RedeemableType redeemableType,
      SizeInOunces redeemableSize,
      Map<String, dynamic> sizePriceMap,
      List<AddIn> addIns,
      List<dynamic> requiredAddIns,
      String size,
      bool servedIced,
      bool soldOut}) {
    return Drink(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        quantity: quantity ?? this.quantity,
        redeemableType: redeemableType ?? this.redeemableType,
        redeemableSize: redeemableSize ?? this.redeemableSize,
        sizePriceMap: sizePriceMap ?? this.sizePriceMap,
        addIns: addIns ?? this.addIns,
        requiredAddIns: requiredAddIns ?? this.requiredAddIns,
        size: size ?? this.size,
        servedIced: servedIced ?? this.servedIced,
        soldOut: soldOut ?? this.soldOut);
  }

  List<Map> _addinsToJson(List<AddIn> addIns) {
    return List.generate(addIns.length, (index) => addIns[index].toJson());
  }
}

class Food extends Item {
  String id;
  String name;
  String price;
  String description;
  String notes;
  int quantity;
  bool soldOut;

  Food(
      {this.id,
      this.name,
      this.price,
      this.notes,
      this.soldOut,
      this.description,
      this.quantity});

  Food copyWith(
      {String id,
      String name,
      String price,
      String description,
      String notes,
      int quantity,
      bool soldOut}) {
    return Food(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        description: description ?? this.description,
        notes: notes ?? this.notes,
        quantity: quantity ?? this.quantity,
        soldOut: soldOut ?? this.soldOut);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'soldOut': soldOut,
      'quantity': quantity,
      'notes': notes,
      'description': description,
    };
  }
}

class AddIn extends Item {
  String id;
  String name;
  String price;
  String description;

  AddIn({this.id, this.name, this.price});

  toJson() {
    return {'id': id, 'name': name, 'price': price, 'description': description};
  }
}

enum SizeInOunces { eight, twelve, sixteen, none }

SizeInOunces redeemableSizeStringToEnum(String type) {
  switch (type) {
    case "8 oz":
      return SizeInOunces.eight;
    case "12 oz":
      return SizeInOunces.twelve;
    case "16 oz":
      return SizeInOunces.sixteen;
    default:
      return SizeInOunces.none;
  }
}

extension RedeemableSizeExtension on SizeInOunces {
  String get value {
    switch (this) {
      case SizeInOunces.eight:
        return "8 oz";
      case SizeInOunces.twelve:
        return "12 oz";
      case SizeInOunces.sixteen:
        return "16 oz";
      default:
        return "none";
    }
  }

  statusToString() {
    return this.value;
  }
}
