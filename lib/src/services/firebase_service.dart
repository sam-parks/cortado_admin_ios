import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/data/message.dart';
import 'package:cortado_admin_ios/src/data/redemption.dart';
import 'package:cortado_admin_ios/src/services/firebase_auth.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authimport;

final FirebaseAuthService auth = FirebaseAuthService();
final firestore = fb.firestore();

CollectionReference get _usersCollection => firestore.collection('users');
CollectionReference get _shopsCollection =>
    firestore.collection('coffee_shops');
CollectionReference get _messagesCollection => firestore.collection('messages');
CollectionReference _coffeeShopsRedemptions(DocumentReference coffeeShop) =>
    coffeeShop.collection('redemptions');
CollectionReference _adminsCollection = firestore.collection('admins');

Future<CortadoUser> registerUser(String email, String password) async {
  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      final _user = await auth.signInWithEmailAndPassword(email, password);
      if (_user != null) {
        DocumentSnapshot snapshot =
            await _usersCollection.doc(_user.user.uid).get();
        authimport.User firebaseUser =
            FirebaseAuthService().currentFirebaseUser();
        CortadoUser cortadoUser =
            CortadoUser.fromSnap(snapshot, firebaseUser: firebaseUser);

        return cortadoUser;
      }
    } catch (e) {
      throw e;
    }
  } else {
    throw "Please fill correct e-mail and password.";
  }
  throw 'Error Communicating with Firebase';
}

getCurrentFirebaseUser() {
  return FirebaseAuthService().currentFirebaseUser();
}

Future<bool> createBarista(String firstName, String lastName, String email,
    String password, String coffeeShopId) async {
  try {
    final _user = await auth.createUser(email, password);
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
      await coffeeShopAdmin.ref.update(data: {'baristas': baristas});
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw e;
  }
}

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
    CollectionReference adminsCollection = firestore.collection('admins');

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
    CollectionReference adminsCollection = firestore.collection('admins');

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

Future<Map<String, List<String>>> drinks(
    DocumentReference coffeeShopRef) async {
  List<String> blackList = [];
  List<String> premiumList = [];
  Map<String, List<String>> drinksMap = {
    'black': blackList,
    'premium': premiumList
  };
  DocumentSnapshot coffeeShopSnap = await coffeeShopRef.get();
  CoffeeShop coffeeShop = CoffeeShop.fromSnapshot(coffeeShopSnap);
  blackList.addAll(coffeeShop.blackCoffees.cast<String>());
  premiumList.addAll(coffeeShop.premiumCoffees);

  return drinksMap;
}

updateDrinks(String coffeeShopId, List<String> drinks, String type) {
  if (type == "black") {
    _shopsCollection.doc(coffeeShopId).update(data: {'blackCoffees': drinks});
  } else {
    _shopsCollection.doc(coffeeShopId).update(data: {'premiumCoffees': drinks});
  }
}

Stream<Redemption> redemptions(DocumentReference coffeeShop) async* {
  var query = await _coffeeShopsRedemptions(coffeeShop).get();
  var remoteSnapshots = query.docs;
  for (var snapshot in remoteSnapshots) {
    DocumentReference redemptionRef = snapshot.data()['redemption'];
    DocumentSnapshot redemptionSnapshot = await redemptionRef.get();
    print(redemptionSnapshot.data());
    var redemption = Redemption.fromSnap(redemptionSnapshot.data());
    yield redemption;
  }
  return;
}

Stream<CortadoUser> users(DocumentReference coffeeShop) async* {
  List<String> users = [];
  var query = await _coffeeShopsRedemptions(coffeeShop).get();
  var remoteSnapshots = query.docs;
  for (var snapshot in remoteSnapshots) {
    DocumentReference userRef = snapshot.data()['customer'];
    if (users.contains(userRef.id)) {
      continue;
    }
    DocumentSnapshot userSnapshot = await userRef.get();
    var user = CortadoUser.fromSnap(userSnapshot);
    yield user;
    users.add(userRef.id);
  }
  return;
}

Stream<CortadoUser> allUsers() async* {
  var usersQuery = await _usersCollection.get();
  var remoteSnapshots = usersQuery.docs;
  for (var snapshot in remoteSnapshots) {
    print(snapshot.id);
    var user = CortadoUser.fromSnap(snapshot);
    yield user;
  }

  return;
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
  CollectionReference adminsCollection = firestore.collection('admins');

  QuerySnapshot adminsQuery = await adminsCollection.get();
  var remoteSnapshots = adminsQuery.docs;
  for (var snapshot in remoteSnapshots) {
    List<dynamic> users = snapshot.data()['users'];
    print(users);
    List<DocumentReference> adminUsers = List.castFrom(users);
    adminUsers.forEach((ref) async {
      DocumentSnapshot snap = await ref.get();
      admins.addAll({ref.id: CortadoUser.fromSnap(snap)});
    });
  }

  return admins;
}

Stream<List<Message>> coffeeShopConversations() async* {
  var conversationsQuery = await _messagesCollection.get();
  var conversationSnapshots = conversationsQuery.docs;

  for (var snapshot in conversationSnapshots) {
    print(snapshot.id);
    List<Message> conversation = await getConversation(snapshot.id);
    yield conversation;
  }
  return;
}

Future<List<Message>> getConversation(String convoId) async {
  List<Message> conversation = [];
  QuerySnapshot convoSnapshot =
      await _messagesCollection.doc(convoId).collection(convoId).get();
  convoSnapshot.forEach(
      (messageSnap) => conversation.add(Message.fromSnap(messageSnap.data())));
  return conversation;
}

Future forgotPassword(String email) async {
  try {
    await auth.sendPasswordResetEmail(email);
  } catch (e) {
    throw e.toString();
  }
}

Future logout() async {
  try {
    await auth.signOut();
  } catch (e) {
    throw e.toString();
  }
  throw 'Error Communicating with Firebase';
}

Future<CortadoUser> checkUser() async {
  try {
    firestore.enablePersistence();

    final _user = await auth.currentUser();
    if (_user != null) {
      print(_user.firebaseUser.email);
      DocumentSnapshot snapshot = await _usersCollection.doc(_user.id).get();
      CortadoUser cortadoUser =
          CortadoUser.fromSnap(snapshot, firebaseUser: _user.firebaseUser);
      if (cortadoUser.isCoffeeShopAdmin || cortadoUser.isCortadoAdmin)
        return cortadoUser;
      else
        throw 'Invalid User';
    }
  } catch (e) {
    throw e.toString();
  }
  throw 'Error Communicating with Firebase';
}

Future<String> uploadImageFile(Uint8List image, String coffeeShop,
    {String imageName}) async {
  fb.StorageReference storageRef =
      fb.storage().ref('images/$coffeeShop/${Random().nextInt(999999)}.jpg');
  fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(image).future;

  Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
  return imageUri.toString();
}

Future<bool> removeUser(CortadoUser member) async {
  try {
    var result = await CloudFunctions.instance
        .getHttpsCallable(functionName: 'user-deleteUser')
        .call({'uid': member.reference.id});
    return result.data['result'];
  } catch (e) {
    return false;
  }
}
