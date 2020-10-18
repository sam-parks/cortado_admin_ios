import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';

class CoffeeShopService {
  final FirebaseFirestore _firestore;
  CoffeeShopService(this._firestore);

  CollectionReference get _shopsCollection =>
      _firestore.collection('coffee_shops');

  Future<CoffeeShop> init(String id) async {
    print("coffeeShopId: " + id);
    DocumentReference ref = _shopsCollection.doc(id);
    DocumentSnapshot snapshot = await ref.get();
    return CoffeeShop.fromSnapshot(snapshot);
  }

  Future<void> updateCoffeeShop(CoffeeShop coffeeShop) async {
    try {
      DocumentReference docRef = _shopsCollection.doc(coffeeShop.id);
      Map<String, dynamic> coffeeShopJson = coffeeShop.toJson();
      await docRef.update(coffeeShopJson);
    } catch (e) {
      print(e);
    }
  }

  allCoffeeShops() async* {
    var shopsQuery = await _shopsCollection.get();
    var remoteSnapshots = shopsQuery.docs;
    for (var snapshot in remoteSnapshots) {
      print(snapshot.id);
      var coffeeShop = CoffeeShop.fromSnapshot(snapshot);
      yield coffeeShop;
    }

    return;
  }

  Future<Map<String, CortadoUser>> allCoffeeShopAdmins() async {
    Map<String, CortadoUser> admins = {};
    CollectionReference adminsCollection = _firestore.collection('admins');

    QuerySnapshot adminsQuery = await adminsCollection.get();
    var remoteSnapshots = adminsQuery.docs;
    for (var snapshot in remoteSnapshots) {
      List<dynamic> users = snapshot.data()['users'];
      List<DocumentReference> adminUsers = List.castFrom(users);
      adminUsers.forEach((ref) async {
        DocumentSnapshot snap = await ref.get();
        admins.addAll({ref.id: CortadoUser.fromSnap(snap)});
      });
    }

    return admins;
  }
}
