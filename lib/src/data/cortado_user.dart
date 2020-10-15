import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/models/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class CortadoUser {
  auth.User firebaseUser;
  String cbCustomerId;
  String cbPlanId;
  UserType userType;
  bool isCoffeeShopAdmin = false;
  bool isCortadoAdmin = false;
  String firstName;
  String lastName;
  String phone;
  String email;
  String coffeeShopId;
  DocumentReference subscription;
  bool termsAgreed = false;
  DocumentReference reference;
  DateTime createdAt;
  DateTime reloadDate;
  DateTime updatedAt;
  String redemptionsLeft;
  CortadoUser({
    this.firebaseUser,
    this.firstName,
    this.lastName,
  })  : this.email = firebaseUser?.email,
        this.phone = firebaseUser?.phoneNumber;

  String get id => firebaseUser?.uid;
  String get displayName => '$firstName $lastName';

  CortadoUser.fromSnap(DocumentSnapshot snapshot, {auth.User firebaseUser})
      : this.fromData(
          snapshot.data(),
          reference: snapshot.reference,
          firebaseUser: firebaseUser,
        );

  CortadoUser.fromData(Map<String, dynamic> data,
      {this.reference, this.firebaseUser}) {
    firstName = data['firstName'];
    lastName = data['lastName'];
    userType = userTypeFromString(data['userType']);
    termsAgreed = data['termsAgreed'] ?? true;
    isCortadoAdmin = data["isCortadoAdmin"];
    isCoffeeShopAdmin = data["isCoffeeShopAdmin"] ?? isCortadoAdmin ?? false;
    phone = data['phone'];
    coffeeShopId = data['coffeeShopId'];
    email = data['email'];
    cbCustomerId = data['cbCustomerId'];
    cbPlanId = data['cbPlanId'];
    subscription = data['subscription'];
    if (data['createdAt'] is String) {
      String date = data['createdAt'].toString().substring(0, 19) + 'Z';
      createdAt = DateTime.parse(date);
    } else {
      createdAt = data['createdAt'];
    }
    if (data['updatedAt'] is String) {
      String date = data['updatedAt'].toString().substring(0, 19) + 'Z';
      updatedAt = DateTime.parse(date);
    } else {
      updatedAt = data['updatedAt'];
    }
    redemptionsLeft =
        data['redemptionsLeft'] != null ? data['redemptionsLeft'] : null;
    if (data['reloadDate'] is String) {
      String date = data['reloadDate'].toString();
      if (date != "") {
        reloadDate = DateTime.parse(date);
      }
    } else {
      reloadDate = data['reloadDate'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "phone": this.phone,
      'coffeeShopId': this.coffeeShopId,
      "cbCustomerId": this.cbCustomerId,
      "cbPlanId": this.cbPlanId,
      "updatedAt": this.updatedAt,
      "isCortadoAdmin": this.isCortadoAdmin,
      "isCoffeeShopAdmin": this.isCoffeeShopAdmin,
      "createdAt": this.createdAt == null
          ? Timestamp.fromDate(DateTime.now())
          : Timestamp(this.createdAt.millisecondsSinceEpoch ~/ 1000, 0),
    };
  }

  Map<String, dynamic> toJsonEncodable() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "userType": this.userType.value,
      "email": this.email,
      "phone": this.phone,
      'coffeeShopId': this.coffeeShopId,
      "cbCustomerId": this.cbCustomerId,
      "cbPlanId": this.cbPlanId,
      "isCortadoAdmin": this.isCortadoAdmin,
      "isCoffeeShopAdmin": this.isCoffeeShopAdmin,
    };
  }

  // ignore: missing_return
  UserType userTypeFromString(String userTypeValue) {
    switch (userTypeValue) {
      case "owner":
        return UserType.owner;
      case "barista":
        return UserType.barista;
      case "superUser":
        return UserType.superUser;
    }
  }
}
