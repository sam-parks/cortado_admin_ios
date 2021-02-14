import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/discount.dart';
import 'package:cortado_admin_ios/src/data/item.dart';
import 'package:cortado_admin_ios/src/ui/pages/menu/menu_category_page.dart';
import 'package:tuple/tuple.dart';

class MenuService {
  final FirebaseFirestore _firestore;

  MenuService(this._firestore);

  CollectionReference get _menusCollection => _firestore.collection('menus');

  Stream<Tuple2<CategoryType, Category>> get items async* {
    yield* _itemController.stream;
  }

  Stream<List<Discount>> get discounts async* {
    yield* _discountController.stream;
  }

  StreamController<Tuple2<CategoryType, Category>> _itemController =
      StreamController<Tuple2<CategoryType, Category>>();

  StreamController<List<Discount>> _discountController =
      StreamController<List<Discount>>();

  getFoodCategories(String coffeeShopId) async {
    QuerySnapshot categoriesSnapshot =
        await _menusCollection.doc(coffeeShopId).collection('food').get();

    for (var catSnap in categoriesSnapshot.docs) {
      _menusCollection
          .doc(coffeeShopId)
          .collection('food')
          .doc(catSnap.id)
          .collection('items')
          .snapshots()
          .listen((itemsSnapshot) {
        List<Item> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return foodFromData(itemsSnapshot.docs[index].data());
        });
        _itemController.add(Tuple2(
            CategoryType.food, Category.fromData(catSnap.data(), templates)));
      });
    }
  }

  getDrinkCategories(String coffeeShopId) async {
    QuerySnapshot categoriesSnapshot =
        await _menusCollection.doc(coffeeShopId).collection('drinks').get();

    for (var catSnap in categoriesSnapshot.docs) {
      _menusCollection
          .doc(coffeeShopId)
          .collection('drinks')
          .doc(catSnap.id)
          .collection('items')
          .snapshots()
          .listen((itemsSnapshot) {
        List<Item> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return drinkFromData(itemsSnapshot.docs[index].data());
        });
        _itemController.add(Tuple2(
            CategoryType.drink, Category.fromData(catSnap.data(), templates)));
      });
    }
  }

  Future<List<Category>> getAddInCategories(String coffeeShopId) async {
    List<Category> addInCategories = [];
    QuerySnapshot categoriesSnapshot =
        await _menusCollection.doc(coffeeShopId).collection('addIns').get();

    for (var catSnap in categoriesSnapshot.docs) {
      _menusCollection
          .doc(coffeeShopId)
          .collection('addIns')
          .doc(catSnap.id)
          .collection('items')
          .snapshots()
          .listen((itemsSnapshot) {
        List<Item> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return addInFromData(itemsSnapshot.docs[index].data());
        });

        addInCategories.add(Category.fromData(catSnap.data(), templates));
      });
    }
    return addInCategories;
  }

  getDiscounts(String coffeeShopId) async {
    _menusCollection
        .doc(coffeeShopId)
        .collection('discounts')
        .snapshots()
        .listen((discountsSnapshot) {
      List<Discount> discounts = [];
      for (var discountSnap in discountsSnapshot.docs) {
        discounts.add(Discount.fromJson(discountSnap.data()));
      }
      _discountController.add(discounts);
    });
  }
}

Drink drinkFromData(Map<dynamic, dynamic> data) {
  Drink drink = Drink(
      addIns: addInsToList(data['addIns']),
      requiredAddIns: data['requiredAddIns'] ?? [],
      availableAddIns: data['availableAddIns'] ?? [],
      id: data['id'],
      name: data['name'],
      size: data['size'],
      soldOut: data['soldOut'] ?? false,
      quantity: data['quantity'] ?? 1,
      servedIced: data['servedIced'],
      redeemableType: redeemableTypeStringToEnum(data['redeemableType']),
      redeemableSize: sizeStringToEnum(data['redeemableSize']),
      sizePriceMap: convertSizePriceMapToJson(data['sizePriceMap']));

  return drink;
}

List<AddIn> addInsToList(List<dynamic> addInMaps) {
  if (addInMaps == null) return [];
  List<AddIn> addIns = [];
  addInMaps.forEach((map) {
    addIns.add(
        AddIn(id: map['id'], name: map['name'], price: map['price'] ?? '0.00'));
  });
  return addIns;
}

Map<SizeInOunces, dynamic> convertSizePriceMapToJson(
    Map<dynamic, dynamic> sizePriceMap) {
  return sizePriceMap
      .map((key, value) => MapEntry(sizeStringToEnum(key), value));
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
