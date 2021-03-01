import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/category.dart';
import 'package:cortado_admin_ios/src/data/discount.dart';
import 'package:cortado_admin_ios/src/data/item_template.dart';
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
        List<ItemTemplate> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return foodTemplateFromData(itemsSnapshot.docs[index].data());
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
        List<ItemTemplate> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return drinkTemplateFromData(itemsSnapshot.docs[index].data());
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
        List<ItemTemplate> templates =
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
        List<ItemTemplate> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return foodTemplateFromData(itemsSnapshot.docs[index].data());
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
        List<ItemTemplate> templates =
            List.generate(itemsSnapshot.docs.length, (index) {
          return drinkTemplateFromData(itemsSnapshot.docs[index].data());
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
        List<ItemTemplate> templates =
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
              .set((drink as DrinkTemplate).toJson());
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
              .set((foodItem as FoodTemplate).toJson());
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
              .set((drink as DrinkTemplate).toJson());
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
              .set((foodItem as FoodTemplate).toJson());
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
      String categoryId, ItemTemplate itemToAdd) {
    switch (categoryType) {
      case CategoryType.drink:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(categoryId)
            .collection('items')
            .doc(itemToAdd.id)
            .set((itemToAdd as DrinkTemplate).toJson());
        break;
      case CategoryType.food:
        FoodTemplate foodTemplate = itemToAdd;
        return _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(categoryId)
            .collection('items')
            .doc(itemToAdd.id)
            .set(foodTemplate.toJson());
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
      String categoryId, ItemTemplate itemToUpdate) {
    switch (categoryType) {
      case CategoryType.drink:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('drinks')
            .doc(categoryId)
            .collection('items')
            .doc(itemToUpdate.id)
            .update((itemToUpdate as DrinkTemplate).toJson());
        break;
      case CategoryType.food:
        return _menusCollection
            .doc(coffeeShopId)
            .collection('food')
            .doc(categoryId)
            .collection('items')
            .doc(itemToUpdate.id)
            .update((itemToUpdate as FoodTemplate).toJson());
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
      String categoryId, ItemTemplate itemToRemove) {
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

List<AddIn> addInsToList(List<dynamic> addInMaps) {
  if (addInMaps == null) return [];
  List<AddIn> addIns = [];
  addInMaps.forEach((map) {
    addIns.add(
        AddIn(id: map['id'], name: map['name'], price: map['price'] ?? '0.00'));
  });
  return addIns;
}

Map<SizeInOunces, dynamic> convertSizePriceMapToObject(
    Map<dynamic, dynamic> sizePriceMap) {
  return sizePriceMap.map((key, value) => MapEntry(
      sizeStringToEnum(key), value == '' || value == null ? '0.00' : value));
}

DrinkTemplate drinkTemplateFromData(Map<dynamic, dynamic> data) {
  DrinkTemplate drinkTemplate = DrinkTemplate(
      id: data['id'],
      name: data['name'],
      servedIced: data['servedIced'] ?? false,
      soldOut: data['soldOut'],
      redeemableSize: sizeStringToEnum(data['redeemableSize']),
      description: data['description'],
      requiredAddIns: data['requiredAddIns'] ?? [],
      availableAddIns: data['availableAddIns'] ?? [],
      redeemableType: redeemableTypeStringToEnum(data['redeemableType']),
      sizePriceMap: convertSizePriceMapToObject(data['sizePriceMap']));
  return drinkTemplate;
}

FoodTemplate foodTemplateFromData(Map<dynamic, dynamic> data) {
  return FoodTemplate(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      soldOut: data['soldOut'],
      description: data['description']);
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
