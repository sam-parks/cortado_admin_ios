import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/services/auth_service.dart';

class BaristaService {
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  BaristaService(this._firestore, this._authService);

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

  Future<bool> createBarista(String firstName, String lastName, String email,
      String password, String coffeeShopId) async {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e;
    }
  }
}
