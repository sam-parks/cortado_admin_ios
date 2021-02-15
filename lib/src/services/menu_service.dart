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

  Stream<Tuple2<CategoryType, List<Category>>> get categories async* {
    yield* _categoryController.stream;
  }

  StreamController<Tuple2<CategoryType, List<Category>>> _categoryController =
      StreamController<Tuple2<CategoryType, List<Category>>>();

  StreamController<Tuple2<CategoryType, Category>> _itemController =
      StreamController<Tuple2<CategoryType, Category>>();

  StreamController<List<Discount>> _discountController =
      StreamController<List<Discount>>();

  getCategories(String coffeeShopId) async {
    _menusCollection
        .doc(coffeeShopId)
        .collection('food')
        .snapshots()
        .listen((categorySnaps) async {
      List<Category> categories = [];
      for (var catSnap in categorySnaps.docs) {
        QuerySnapshot itemsSnapshot = await _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(catSnap.id)
            .collection('items')
            .get();
        List<Item> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return foodFromData(itemsSnapshot.docs[index].data());
        });
        categories.add(Category.fromData(catSnap.data(), templates));
      }
      _categoryController.add(Tuple2(CategoryType.food, categories));
    });

    _menusCollection
        .doc(coffeeShopId)
        .collection('drinks')
        .snapshots()
        .listen((categorySnaps) async {
      List<Category> categories = [];
      for (var catSnap in categorySnaps.docs) {
        QuerySnapshot itemsSnapshot = await _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(catSnap.id)
            .collection('items')
            .get();
        List<Item> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return drinkFromData(itemsSnapshot.docs[index].data());
        });
        categories.add(Category.fromData(catSnap.data(), templates));
      }
      _categoryController.add(Tuple2(CategoryType.drink, categories));
    });

    _menusCollection
        .doc(coffeeShopId)
        .collection('addIns')
        .snapshots()
        .listen((categorySnaps) async {
      List<Category> categories = [];
      for (var catSnap in categorySnaps.docs) {
        QuerySnapshot itemsSnapshot = await _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(catSnap.id)
            .collection('items')
            .get();
        List<Item> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return addInFromData(itemsSnapshot.docs[index].data());
        });
        categories.add(Category.fromData(catSnap.data(), templates));
      }
      _categoryController.add(Tuple2(CategoryType.addIn, categories));
    });
  }

  getFoodItems(String coffeeShopId) async {
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

  getDrinkItems(String coffeeShopId) async {
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

  getAddInItems(String coffeeShopId) async {
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

        _itemController.add(Tuple2(
            CategoryType.addIn, Category.fromData(catSnap.data(), templates)));
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

  addCategory(
      String coffeeShopId, CategoryType categoryType, Category category) async {
    switch (categoryType) {
      case CategoryType.drink:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(category.id)
            .set(category.toJson());

        category.items.forEach((drink) {
          _menusCollection
              .doc(coffeeShopId)
              .collection('drinks')
              .doc(category.id)
              .collection('items')
              .doc(drink.id)
              .set((drink as Drink).toJson());
        });
        break;
      case CategoryType.food:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(category.id)
            .set(category.toJson());

        category.items.forEach((foodItem) {
          _menusCollection
              .doc(coffeeShopId)
              .collection('food')
              .doc(category.id)
              .collection('items')
              .doc(foodItem.id)
              .set((foodItem as Food).toJson());
        });
        break;
      case CategoryType.addIn:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(category.id)
            .set(category.toJson());

        category.items.forEach((addIn) {
          _menusCollection
              .doc(coffeeShopId)
              .collection('addIns')
              .doc(category.id)
              .collection('items')
              .doc(addIn.id)
              .set((addIn as AddIn).toJson());
        });
        break;
    }
  }

  removeCategory(
      String coffeeShopId, CategoryType categoryType, Category category) async {
    switch (categoryType) {
      case CategoryType.drink:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(category.id)
            .delete();

        break;
      case CategoryType.food:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(category.id)
            .delete();

        break;
      case CategoryType.addIn:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(category.id)
            .delete();

        break;
    }
  }

  updateCategory(
      String coffeeShopId, CategoryType categoryType, Category category) async {
    switch (categoryType) {
      case CategoryType.drink:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(category.id)
            .set(category.toJson());

        category.items.forEach((drink) {
          _menusCollection
              .doc(coffeeShopId)
              .collection('drinks')
              .doc(category.id)
              .collection('items')
              .doc(drink.id)
              .set((drink as Drink).toJson());
        });
        break;
      case CategoryType.food:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(category.id)
            .set(category.toJson());

        category.items.forEach((foodItem) {
          _menusCollection
              .doc(coffeeShopId)
              .collection('food')
              .doc(category.id)
              .collection('items')
              .doc(foodItem.id)
              .set((foodItem as Food).toJson());
        });
        break;
      case CategoryType.addIn:
        await _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(category.id)
            .set(category.toJson());

        category.items.forEach((addIn) {
          _menusCollection
              .doc(coffeeShopId)
              .collection('addIns')
              .doc(category.id)
              .collection('items')
              .doc(addIn.id)
              .set((addIn as AddIn).toJson());
        });
        break;
    }
  }

  addItemInCategory(String coffeeShopId, CategoryType categoryType,
      String categoryId, Item itemToAdd) {
    switch (categoryType) {
      case CategoryType.drink:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(categoryId)
            .collection('items')
            .doc(itemToAdd.id)
            .set((itemToAdd as Drink).toJson());
        break;
      case CategoryType.food:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(categoryId)
            .collection('items')
            .doc(itemToAdd.id)
            .set((itemToAdd as Food).toJson());
        break;
      case CategoryType.addIn:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(categoryId)
            .collection('items')
            .doc(itemToAdd.id)
            .set((itemToAdd as AddIn).toJson());
        break;
    }
  }

  updateItemInCategory(String coffeeShopId, CategoryType categoryType,
      String categoryId, Item itemToUpdate) {
    switch (categoryType) {
      case CategoryType.drink:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(categoryId)
            .collection('items')
            .doc(itemToUpdate.id)
            .update((itemToUpdate as Drink).toJson());
        break;
      case CategoryType.food:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(categoryId)
            .collection('items')
            .doc(itemToUpdate.id)
            .update((itemToUpdate as Food).toJson());
        break;
      case CategoryType.addIn:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(categoryId)
            .collection('items')
            .doc(itemToUpdate.id)
            .update((itemToUpdate as AddIn).toJson());
        break;
    }
  }

  removeItemInCategory(String coffeeShopId, CategoryType categoryType,
      String categoryId, Item itemToRemove) {
    switch (categoryType) {
      case CategoryType.drink:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(categoryId)
            .collection('items')
            .doc(itemToRemove.id)
            .delete();
        break;
      case CategoryType.food:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(categoryId)
            .collection('items')
            .doc(itemToRemove.id)
            .delete();
        break;
      case CategoryType.addIn:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('addIns')
            .doc(categoryId)
            .collection('items')
            .doc(itemToRemove.id)
            .delete();
        break;
    }
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
      sizePriceMap: convertSizePriceMap(data['sizePriceMap']));

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

Map<SizeInOunces, dynamic> convertSizePriceMap(
    Map<dynamic, dynamic> sizePriceMap) {
  return sizePriceMap.map((key, value) => MapEntry(
      sizeStringToEnum(key), value == '' || value == null ? '0.00' : value));
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
