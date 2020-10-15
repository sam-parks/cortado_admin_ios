import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;

class CoffeeShopService {
  CoffeeShopService._();
  static CoffeeShopService _instance = CoffeeShopService._();
  static CoffeeShopService get instance => _instance;
  final firestore = fb.firestore();

  CollectionReference get _shopsCollection =>
      firestore.collection('coffee_shops');

  Future<void> updateCoffeeShop(CoffeeShop coffeeShop) async {
    try {
      DocumentReference docRef = _shopsCollection.doc(coffeeShop.id);
      Map<String, dynamic> coffeeShopJson = coffeeShop.toJson();
      await docRef.update(data: coffeeShopJson);
    } catch (e) {
      print(e);
    }
  }
}
