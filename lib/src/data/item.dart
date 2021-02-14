import 'package:cortado_admin_ios/src/services/menu_service.dart';

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
  Map<SizeInOunces, dynamic> sizePriceMap;
  List<AddIn> addIns;
  List<dynamic> requiredAddIns;
  List<dynamic> availableAddIns;
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
      this.availableAddIns,
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
      'availableAddIns': availableAddIns,
      'quantity': quantity,
      'soldOut': soldOut ?? false,
      'servedIced': servedIced,
      'redeemableSize': redeemableSize.sizeToString(),
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
      List<String> availableAddIns,
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
        availableAddIns: availableAddIns ?? this.availableAddIns,
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

enum SizeInOunces {
  six,
  sixIced,
  eight,
  eightIced,
  twelve,
  twelveIced,
  sixteen,
  sixteenIced,
  twenty,
  twentyIced,
  twentyFour,
  twentyFourIced,
  none
}

SizeInOunces sizeStringToEnum(String type) {
  switch (type) {
    case "6 oz":
      return SizeInOunces.six;
    case "6 oz Iced":
      return SizeInOunces.sixIced;
    case "8 oz":
      return SizeInOunces.eight;
    case "8 oz Iced":
      return SizeInOunces.eightIced;
    case "12 oz":
      return SizeInOunces.twelve;
    case "12 oz Iced":
      return SizeInOunces.twelveIced;
    case "16 oz":
      return SizeInOunces.sixteen;
    case "16 oz Iced":
      return SizeInOunces.sixteenIced;
    case "20 oz":
      return SizeInOunces.twenty;
    case "20 oz Iced":
      return SizeInOunces.twentyIced;
    case "24 oz":
      return SizeInOunces.twentyFour;
    case "24 oz Iced":
      return SizeInOunces.twentyFourIced;
    default:
      return SizeInOunces.none;
  }
}

extension RedeemableSizeExtension on SizeInOunces {
  String get value {
    switch (this) {
      case SizeInOunces.six:
        return "6 oz";
        break;
      case SizeInOunces.sixIced:
        return "6 oz Iced";
        break;
      case SizeInOunces.eight:
        return "8 oz";
      case SizeInOunces.eightIced:
        return "8 oz Iced";
        break;
      case SizeInOunces.twelve:
        return "12 oz";
      case SizeInOunces.twelveIced:
        return "12 oz Iced";
        break;
      case SizeInOunces.sixteen:
        return "16 oz";
      case SizeInOunces.sixteenIced:
        return "16 oz Iced";
        break;
      case SizeInOunces.twenty:
        return "20 oz";
        break;
      case SizeInOunces.twentyIced:
        return "20 oz Iced";
        break;
      case SizeInOunces.twentyFour:
        return "24 oz";
      case SizeInOunces.twentyFourIced:
        return "24 oz Iced";
      default:
        return "none";
    }
  }

  sizeToString() {
    return this.value;
  }
}
