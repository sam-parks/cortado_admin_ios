import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item.dart';

class CoffeeShop {
  final String id;
  final String name;
  final Map<dynamic, dynamic> address;
  final List<dynamic> blackCoffees;
  final String createdAt;
  final String updatedAt;
  final String description;
  final String disabledReason;
  final String picture;
  final Map hours;
  final String phone;
  final List<String> premiumCoffees;
  final DocumentReference reference;
  final List<Category> addIns;
  final List<Category> drinks;
  final List<Category> food;
  final List<dynamic> sizes;
  final List<dynamic> discounts;
  final String customStripeAccountId;
  final bool needsVerificationUpdate;

  const CoffeeShop({
    this.reference,
    this.name,
    this.address,
    this.phone,
    this.hours,
    this.sizes,
    this.blackCoffees,
    this.createdAt,
    this.description,
    this.disabledReason,
    this.premiumCoffees,
    this.addIns,
    this.updatedAt,
    this.drinks,
    this.food,
    this.needsVerificationUpdate,
    this.customStripeAccountId,
    this.discounts,
    this.picture,
    this.id,
  });

  CoffeeShop copyWith(
      {String id,
      String name,
      Map<dynamic, dynamic> address,
      List<dynamic> blackCoffees,
      String createdAt,
      String updatedAt,
      String description,
      String disabledReason,
      String picture,
      Map hours,
      String phone,
      List<String> premiumCoffees,
      DocumentReference reference,
      List<Category> addIns,
      List<Category> drinks,
      List<Category> food,
      List<dynamic> sizes,
      List<dynamic> discounts,
      String customStripeAccountId,
      bool needsVerificationUpdate}) {
    return CoffeeShop(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        name: name ?? this.name,
        address: address ?? this.address,
        hours: hours ?? this.hours,
        sizes: sizes ?? this.sizes,
        blackCoffees: blackCoffees ?? this.blackCoffees,
        createdAt: createdAt ?? this.createdAt,
        description: description ?? this.description,
        disabledReason: disabledReason ?? this.disabledReason,
        premiumCoffees: premiumCoffees ?? this.premiumCoffees,
        addIns: addIns ?? this.addIns,
        updatedAt: updatedAt ?? this.updatedAt,
        drinks: drinks ?? this.drinks,
        food: food ?? this.food,
        needsVerificationUpdate:
            needsVerificationUpdate ?? this.needsVerificationUpdate,
        customStripeAccountId:
            customStripeAccountId ?? this.customStripeAccountId,
        discounts: discounts ?? this.discounts,
        picture: picture ?? this.picture,
        phone: phone ?? this.phone);
  }

  CoffeeShop copy(CoffeeShop coffeeShop) {
    return CoffeeShop(
        id: coffeeShop.id ?? this.id,
        reference: coffeeShop.reference ?? this.reference,
        name: coffeeShop.name ?? this.name,
        address: coffeeShop.address ?? this.address,
        hours: coffeeShop.hours ?? this.hours,
        sizes: coffeeShop.sizes ?? this.sizes,
        blackCoffees: coffeeShop.blackCoffees ?? this.blackCoffees,
        createdAt: coffeeShop.createdAt ?? this.createdAt,
        description: coffeeShop.description ?? this.description,
        disabledReason: coffeeShop.disabledReason ?? this.disabledReason,
        premiumCoffees: coffeeShop.premiumCoffees ?? this.premiumCoffees,
        addIns: coffeeShop.addIns ?? this.addIns,
        updatedAt: coffeeShop.updatedAt ?? this.updatedAt,
        drinks: coffeeShop.drinks ?? this.drinks,
        food: coffeeShop.food ?? this.food,
        needsVerificationUpdate:
            coffeeShop.needsVerificationUpdate ?? this.needsVerificationUpdate,
        customStripeAccountId:
            coffeeShop.customStripeAccountId ?? this.customStripeAccountId,
        discounts: coffeeShop.discounts ?? this.discounts,
        picture: coffeeShop.picture ?? this.picture,
        phone: coffeeShop.phone ?? this.phone);
  }

  CoffeeShop.fromSnapshot(dynamic snapshot)
      : this.fromData(snapshot.data(), reference: snapshot.reference);

  /// Empty user which represents an uninitialized coffee Shop.
  static const empty = const CoffeeShop();

  CoffeeShop.fromData(Map<dynamic, dynamic> data, {this.reference})
      : this.id = reference.id,
        this.name = data['name'],
        this.drinks = drinksToObjects(data),
        this.food = foodToObjects(data),
        this.sizes = data['sizes'],
        this.addIns = addInsToCategory(data),
        this.customStripeAccountId = data["customStripeAccountId"],
        this.discounts = data['discounts'] ?? [],
        this.address = data['address'],
        this.needsVerificationUpdate = data['needsVerificationUpdate'] ?? true,
        this.blackCoffees = List<String>.from(data['blackCoffees']),
        this.createdAt = data['createdAt'],
        this.updatedAt = data['updatedAt'],
        this.description = data['description'],
        this.disabledReason = data['disabledReason'],
        this.hours = data['hours'],
        this.phone = data['phone'],
        this.picture = data['picture'],
        this.premiumCoffees = List<String>.from(data['premiumCoffees']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'hours': hours,
      'sizes': sizes,
      'addIns': _addInsToJson(addIns),
      'needsVerificationUpdate': needsVerificationUpdate,
      'drinks': _drinksToJson(drinks),
      'food': _foodToJson(food),
      'customStripeAccountId': customStripeAccountId,
      'discounts': discounts,
      'blackCoffees': blackCoffees,
      'createdAt': createdAt,
      'description': description,
      'disabledReason': disabledReason,
      'premiumCoffees': premiumCoffees,
      'updatedAt': updatedAt,
      'picture': picture
    };
  }

  List<Map<dynamic, dynamic>> _addInsToJson(List<Category> addIns) {
    List<Map<dynamic, dynamic>> addInMaps = [];
    addIns.forEach((addInCat) {
      addInCat.items = addInCat.items.cast<AddIn>();
      addInMaps.add(addInCat.toJson());
    });
    return addInMaps;
  }

  List<Map<dynamic, dynamic>> _drinksToJson(List<Category> drinks) {
    List<Map<dynamic, dynamic>> drinkMaps = [];

    drinks.forEach((drinkCat) {
      drinkCat.items = drinkCat.items.cast<Drink>();
      drinkMaps.add(drinkCat.toJson());
    });
    return drinkMaps;
  }

  List<Map<dynamic, dynamic>> _foodToJson(List<Category> drinks) {
    List<Map<dynamic, dynamic>> foodMaps = [];
    drinks.forEach((foodCat) {
      foodCat.items = foodCat.items.cast<Food>();
      foodMaps.add(foodCat.toJson());
    });
    return foodMaps;
  }
}

categoryFromData(
    String id, List<Item> items, String title, String description) {
  return Category(id, items, title, description);
}

Drink drinkFromData(Map<dynamic, dynamic> data) {
  Drink drink = Drink(
      addIns: addInsToList(data['addIns']),
      requiredAddIns: data['requiredAddIns'] ?? [],
      id: data['id'],
      name: data['name'],
      size: data['size'],
      soldOut: data['soldOut'] ?? false,
      quantity: data['quantity'] ?? 1,
      servedIced: data['servedIced'],
      redeemableType: redeemableTypeStringToEnum(data['redeemableType']),
      redeemableSize: redeemableSizeStringToEnum(data['redeemableSize']),
      sizePriceMap: data['sizePriceMap']);

  return drink;
}

List<AddIn> addInsToList(List<dynamic> addInMaps) {
  if (addInMaps == null) return [];
  List<AddIn> addIns = [];
  addInMaps.forEach((map) {
    addIns.add(
        AddIn(id: map['id'], name: map['name'], price: map['price'] ?? []));
  });
  return addIns;
}

Food foodFromData(Map<dynamic, dynamic> data) {
  return Food(
      id: data['id'],
      name: data['name'],
      notes: data['notes'],
      soldOut: data['soldOut'] ?? false,
      quantity: data['quantity'] ?? 1,
      price: data['price'] ?? []);
}

List<Category> drinksToObjects(Map<dynamic, dynamic> data) {
  List<dynamic> drinkList = data['drinks'] ?? [];
  if (drinkList.isEmpty) {
    return [];
  }
  if (data['drinks'][0]['items'] == null) {
    return [];
  }
  return List.generate(
          data['drinks'].length,
          (catIndex) => categoryFromData(
              data['drinks'][catIndex]['id'],
              List.generate(data['drinks'][catIndex]['items']?.length, (index) {
                Map<dynamic, dynamic> drinkMap =
                    data['drinks'][catIndex]['items'][index];

                return drinkMap != null ? drinkFromData(drinkMap) : [];
              }),
              data['drinks'][catIndex]['title'],
              data['drinks'][catIndex]['description'])) ??
      [];
}

List<Category> foodToObjects(Map<dynamic, dynamic> data) {
  List<dynamic> foodList = data['food'] ?? [];
  if (foodList.isEmpty) {
    return [];
  }
  if (data['food'][0]['items'] == null) {
    return [];
  }
  return List.generate(
          data['food'].length,
          (catIndex) => categoryFromData(
              data['food'][catIndex]['id'],
              List.generate(
                  data['food'][catIndex]['items']?.length,
                  (index) =>
                      foodFromData(data['food'][catIndex]['items'][index])),
              data['food'][catIndex]['title'],
              data['food'][catIndex]['description'])) ??
      [];
}

List<Category> addInsToCategory(Map<dynamic, dynamic> data) {
  List<dynamic> addInsList = data['addIns'] ?? [];
  if (addInsList.isEmpty) {
    return [];
  }
  if (data['addIns'][0]['items'] == null) {
    return [];
  }
  return List.generate(
          data['addIns'].length,
          (catIndex) => categoryFromData(
              data['addIns'][catIndex]['id'],
              List.generate(
                  data['addIns'][catIndex]['items']?.length,
                  (index) =>
                      addInFromData(data['addIns'][catIndex]['items'][index])),
              data['addIns'][catIndex]['title'],
              data['addIns'][catIndex]['description'])) ??
      [];
}

AddIn addInFromData(Map<dynamic, dynamic> data) {
  return AddIn(id: data['id'], name: data['name'], price: data['price']);
}

enum RedeemableType { black, premium, none }

RedeemableType redeemableTypeStringToEnum(String type) {
  switch (type) {
    case "black":
      return RedeemableType.black;
    case "premium":
      return RedeemableType.black;
    default:
      return RedeemableType.none;
  }
}

extension RedeemableTypeExtension on RedeemableType {
  String get value {
    switch (this) {
      case RedeemableType.black:
        return "black";
      case RedeemableType.premium:
        return "premium";
      default:
        return "none";
    }
  }

  statusToString() {
    return this.value;
  }
}
