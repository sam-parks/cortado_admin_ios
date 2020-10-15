import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';

class CoffeeShopsModel extends ChangeNotifier {
  List<CoffeeShop> coffeeShops = [];
  bool _mounted = true;
  bool get mounted => _mounted;

  List<CoffeeShop> get list => coffeeShops;
  updateCoffeeShops(List<CoffeeShop> coffeeShops) {
    this.coffeeShops = coffeeShops;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}

class CoffeeShop {
  String id;
  String name;
  Map<dynamic, dynamic> address;
  List<dynamic> blackCoffees;
  String createdAt;
  String updatedAt;
  String description;
  String disabledReason;
  String picture;
  Map hours;
  RedeemableType redeemableType;
  String phone;
  List<String> premiumCoffees;
  DocumentReference reference;
  double currentDistance;
  List<Category> addIns;
  List<Category> drinks;
  List<Category> food;
  List<dynamic> sizes;
  List<dynamic> discounts;
  List<dynamic> activeDeals;
  String customStripeAccountId;
  bool needsVerificationUpdate;

  CoffeeShop(
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
      this.currentDistance,
      this.picture);

  CoffeeShop.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromData(snapshot.data(), reference: snapshot.ref);

  CoffeeShop.fromData(Map<dynamic, dynamic> data, {this.reference}) {
    this.id = reference.id;
    this.name = data['name'];
    this.drinks = drinksToObjects(data);
    this.food = foodToObjects(data);
    this.sizes = data['sizes'];
    this.addIns = addInsToCategory(data);
    this.customStripeAccountId = data["customStripeAccountId"];
    this.discounts = data['discounts'] ?? [];
    this.address = data['address'];
    this.needsVerificationUpdate = data['needsVerificationUpdate'] ?? true;
    List<dynamic> blacks = data['blackCoffees'];
    this.blackCoffees = List<String>.from(blacks);
    this.createdAt = data['createdAt'];
    this.updatedAt = data['updatedAt'];
    this.description = data['description'];
    this.disabledReason = data['disabledReason'];
    this.hours = data['hours'];
    this.phone = data['phone'];
    this.picture = data['picture'];
    List<dynamic> premiums = data['premiumCoffees'];
    this.premiumCoffees = List<String>.from(premiums);
  }

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
      id: data['id'],
      name: data['name'],
      size: data['size'],
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
