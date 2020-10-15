import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class CoffeeShopState extends ChangeNotifier {
  CoffeeShop _coffeeShop;
  bool initialized = false;
  final firestore = fb.firestore();
  CollectionReference get _shopsCollection =>
      firestore.collection('coffee_shops');

  CoffeeShop get coffeeShop => _coffeeShop;

  bool get hasCoffeeShop => _coffeeShop != null;

  void init(String id) async {
    print("coffeeShopId: " + id);
    DocumentReference ref = _shopsCollection.doc(id);
    DocumentSnapshot snapshot = await ref.get();
    _coffeeShop = CoffeeShop.fromSnapshot(snapshot);
    initialized = true;
    print("Coffee Shop initialized");
    notifyListeners();
  }

  update(CoffeeShop coffeeShop) {
    _coffeeShop = coffeeShop;
    notifyListeners();
  }

  clearCoffeeShop() {
    _coffeeShop = null;
  }
}
