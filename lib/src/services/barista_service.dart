import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/auth_service.dart';

class BaristaService {
  final FirebaseFirestore _firestore;
  AuthService get _authService => locator.get();

  BaristaService(this._firestore);

  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _adminsCollection => _firestore.collection('admins');
  Future<List<CortadoUser>> retrieveBaristas(String coffeeShopId) async {
    try {
      List<CortadoUser> baristaList = [];
      DocumentSnapshot coffeeShopAdmin =
          await _adminsCollection.doc(coffeeShopId).get();
      List<dynamic> baristas = coffeeShopAdmin.data()['baristas'] ?? [];
      List<DocumentReference> baristaRefs = List.castFrom(baristas);
      for (var baristaRef in baristaRefs) {
        DocumentSnapshot baristaSnap = await baristaRef.get();
        baristaList.add(CortadoUser.fromSnap(baristaSnap));
      }

      return baristaList;
    } catch (e) {
      throw e;
    }
  }

  Future<CortadoUser> createBarista(String firstName, String lastName,
      String email, String password, String coffeeShopId) async {
    try {
      final _user = await _authService.createUser(email, password);
      if (_user != null) {
        DocumentReference ref = await _usersCollection.add({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          'coffeeShopId': coffeeShopId
        });
        DocumentSnapshot coffeeShopAdmin =
            await _adminsCollection.doc(coffeeShopId).get();
        List<dynamic> baristas = coffeeShopAdmin.data()['baristas'];
        baristas.add(ref);
        await coffeeShopAdmin.reference.update({'baristas': baristas});
        return CortadoUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            coffeeShopId: coffeeShopId);
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }
}
