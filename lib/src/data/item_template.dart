import 'package:cortado_admin_ios/src/services/menu_service.dart';
import 'package:equatable/equatable.dart';

abstract class ItemTemplate {
  String id;
  String name;
  String price;
  String description;

  ItemTemplate(this.id, this.name, this.price, this.description);
}

class DrinkTemplate extends ItemTemplate with EquatableMixin {
  final String id;
  final String name;
  final Map sizePriceMap;
  final String description;
  final RedeemableType redeemableType;
  final SizeInOunces redeemableSize;
  final bool servedIced;
  final List<dynamic> requiredAddIns;
  final List<dynamic> availableAddIns;
  final bool soldOut;

  DrinkTemplate({
    this.id,
    this.redeemableSize,
    this.description,
    this.availableAddIns,
    this.name,
    this.sizePriceMap,
    this.servedIced,
    this.redeemableType,
    this.soldOut = false,
    this.requiredAddIns,
  }) : super(id, name, null, description);

  toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'redeemableType': redeemableType.statusToString(),
      'redeemableSize': redeemableSize.sizeToString(),
      'servedIced': servedIced,
      'soldOut': soldOut
    };
  }

  DrinkTemplate copyWith(
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
    return DrinkTemplate(
        id: id ?? this.id,
        availableAddIns: availableAddIns ?? this.availableAddIns,
        name: name ?? this.name,
        description: description ?? this.description,
        redeemableType: redeemableType ?? this.redeemableType,
        redeemableSize: redeemableSize ?? this.redeemableSize,
        sizePriceMap: sizePriceMap ?? this.sizePriceMap,
        requiredAddIns: requiredAddIns ?? this.requiredAddIns,
        servedIced: servedIced ?? this.servedIced,
        soldOut: soldOut ?? this.soldOut);
  }

  @override
  List<Object> get props =>
      [id, name, description, price, redeemableType, soldOut];
}

class FoodTemplate extends ItemTemplate with EquatableMixin {
  final String id;
  final String name;
  final String price;
  final String description;
  final bool soldOut;

  FoodTemplate(
      {this.id,
      this.description,
      this.name,
      this.price = "0.00",
      this.soldOut = false})
      : super(id, name, price, description);

  toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'description': this.description,
      'soldOut': this.soldOut
    };
  }

  FoodTemplate copyWith(
      {String id,
      String name,
      String price,
      String description,
      bool soldOut}) {
    return FoodTemplate(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        description: description ?? this.description,
        soldOut: soldOut ?? this.soldOut);
  }

  @override
  List<Object> get props => [id, description, name, price, soldOut];
}

class AddIn extends ItemTemplate {
  final String id;
  final String name;
  final String price;

  AddIn({this.id, this.name, this.price = "0.00"}) : super(id, name, price, '');

  toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
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
