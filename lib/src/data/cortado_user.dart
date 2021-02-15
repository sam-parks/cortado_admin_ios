import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CortadoUser {
  final User firebaseUser;
  final String cbCustomerId;
  final String cbPlanId;
  final UserType userType;
  final bool isCoffeeShopAdmin;
  final bool isCortadoAdmin;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String coffeeShopId;
  final DocumentReference subscription;
  final bool termsAgreed;
  final DocumentReference reference;

  const CortadoUser(
      {this.cbCustomerId,
      this.cbPlanId,
      this.userType,
      this.isCoffeeShopAdmin,
      this.isCortadoAdmin,
      this.coffeeShopId,
      this.subscription,
      this.termsAgreed,
      this.reference,
      this.firebaseUser,
      this.firstName,
      this.lastName,
      this.email,
      this.phone});

  CortadoUser copyWith(
      {User firebaseUser,
      String cbCustomerId,
      String cbPlanIdm,
      UserType userType,
      bool isCoffeeShopAdmin,
      bool isCortadoAdmin,
      String firstName,
      String lastName,
      String phone,
      String email,
      String coffeeShopId,
      DocumentReference subscription,
      bool termsAgreed,
      DocumentReference reference}) {
    return CortadoUser(
        cbCustomerId: cbCustomerId ?? this.cbCustomerId,
        cbPlanId: cbPlanId ?? this.cbPlanId,
        userType: userType ?? this.userType,
        isCoffeeShopAdmin: isCoffeeShopAdmin ?? this.isCoffeeShopAdmin,
        isCortadoAdmin: isCortadoAdmin ?? this.isCortadoAdmin,
        coffeeShopId: coffeeShopId ?? this.coffeeShopId,
        subscription: subscription ?? this.subscription,
        termsAgreed: termsAgreed ?? this.termsAgreed,
        reference: reference ?? this.reference,
        firebaseUser: firebaseUser ?? this.firebaseUser,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone);
  }

  String get id => firebaseUser?.uid;
  String get displayName => '$firstName $lastName';

  /// Empty user which represents an unauthenticated user.
  static const empty = const CortadoUser(
      email: '', firebaseUser: null, firstName: '', lastName: '');

  CortadoUser.fromSnap(DocumentSnapshot snapshot, {User firebaseUser})
      : this.fromData(
          snapshot.data(),
          reference: snapshot.reference,
          firebaseUser: firebaseUser,
        );

  CortadoUser.fromData(Map<String, dynamic> data,
      {this.reference, this.firebaseUser})
      : firstName = data['firstName'] ?? '',
        lastName = data['lastName'],
        userType = userTypeFromString(data['userType']),
        termsAgreed = data['termsAgreed'] ?? true,
        isCortadoAdmin = data["isCortadoAdmin"],
        isCoffeeShopAdmin = data["isCoffeeShopAdmin"] ?? false,
        phone = data['phone'],
        coffeeShopId = data['coffeeShopId'],
        email = data['email'],
        cbCustomerId = data['cbCustomerId'],
        cbPlanId = data['cbPlanId'],
        subscription = data['subscription'];

  Map<String, dynamic> toJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "phone": this.phone,
      'coffeeShopId': this.coffeeShopId,
      "cbCustomerId": this.cbCustomerId,
      "cbPlanId": this.cbPlanId,
      "isCortadoAdmin": this.isCortadoAdmin,
      "isCoffeeShopAdmin": this.isCoffeeShopAdmin,
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

enum UserType { barista, owner, superUser }

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.superUser:
        return "superUser";
        break;
      case UserType.barista:
        return "barista";
        break;
      case UserType.owner:
        return "owner";
        break;
      default:
        return "error";
    }
  }

  userTypeToString() {
    return this.value;
  }
}
