import 'package:cortado_admin_ios/src/data/coffee_shop.dart';

abstract class Item {
  String id;
  String name;
  String description;
}

class Drink extends Item {
  String id;
  String name;
  String description;
  RedeemableType redeemableType;
  SizeInOunces redeemableSize;
  Map sizePriceMap;
  List<AddIn> addIns;
  String size;
  bool servedIced;

  Drink(
      {this.id,
      this.name,
      this.size,
      this.sizePriceMap,
      this.addIns,
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
      'servedIced': servedIced,
      'redeemableSize': redeemableSize.statusToString(),
      'redeemableType': redeemableType.statusToString(),
      'addIns': addIns != null ? _addinsToJson(addIns) : null
    };
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

  Food({this.id, this.name, this.price, this.notes, this.description});

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'notes': notes,
      'description': description,
    };
  }
}

class AddIn extends Item {
  String id;
  String name;
  String price;

  AddIn({this.id, this.name, this.price});

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
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
