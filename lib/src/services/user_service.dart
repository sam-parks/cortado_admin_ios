import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserService {
  final FirebaseFirestore _firestore;
  UserService(this._firestore);

  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _adminsCollection => _firestore.collection('admins');


  Future<CortadoUser> saveUser(CortadoUser userData) async {
    DocumentReference docRef = _usersCollection.doc(userData.firebaseUser.uid);
    //userData.createdAt = DateTime.now();
    Map<String, dynamic> userDataJson = userData.toJson();
    await docRef.set(userDataJson);
    CortadoUser updatedUser = userData.copyWith(reference: docRef);

    return updatedUser;
  }

  Future<bool> checkCortadoFullAdmin(CortadoUser user) async {
    try {
      DocumentSnapshot snapshot = await _adminsCollection.doc('full').get();
      List<dynamic> users = snapshot.data()['users'];
      print(users);
      List<DocumentReference> adminUsers = List.castFrom(users);
      bool isAdmin = false;
      adminUsers.forEach((reference) {
        if (reference.id == user.id) {
          isAdmin = true;
        }
      });
      return isAdmin;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> checkCoffeeShopAdmin(CortadoUser user) async {
    try {
      CollectionReference adminsCollection = _firestore.collection('admins');

      DocumentSnapshot snapshot =
          await adminsCollection.doc(user.coffeeShopId).get();
      DocumentReference owner = snapshot.data()['owner'];
      print("Coffee Shop owner: " + owner.id);

      return user.id == owner.id;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> checkBarista(CortadoUser user) async {
    try {
      CollectionReference adminsCollection = _firestore.collection('admins');

      DocumentSnapshot snapshot =
          await adminsCollection.doc(user.coffeeShopId).get();
      List<dynamic> baristas = snapshot.data()['baristas'];
      List<DocumentReference> baristaRefs = List.castFrom(baristas);
      bool isBarista = false;
      baristaRefs.forEach((reference) {
        if (reference.id == user.id) {
          isBarista = true;
        }
      });
      return isBarista;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> updateUser(CortadoUser userData) async {
    try {
      DocumentReference docRef =
          _usersCollection.doc(userData.firebaseUser.uid);
      Map<String, dynamic> userJson = userData.toJson();
      await docRef.update(userJson);
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference> userRef(CortadoUser user) async {
    return _usersCollection.doc(user.firebaseUser.uid);
  }

  Future<CortadoUser> getUser(auth.User firebaseUser) async {
    try {
      DocumentSnapshot snapshot =
          await _usersCollection.doc(firebaseUser.uid).get();
      return CortadoUser.fromSnap(snapshot, firebaseUser: firebaseUser);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> userExists(auth.User firebaseUser) async {
    try {
      DocumentSnapshot snapshot =
          await _usersCollection.doc(firebaseUser.uid).get();
      return snapshot.exists;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> matchPhoneNumber(String phone) async {
    QuerySnapshot querySnap =
        await _usersCollection.where("phone", isEqualTo: phone).get();

    if (querySnap.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<CortadoUser> getUserFromId(String userId) async {
    DocumentSnapshot snapshot = await _usersCollection.doc(userId).get();
    return CortadoUser.fromSnap(snapshot);
  }
}
