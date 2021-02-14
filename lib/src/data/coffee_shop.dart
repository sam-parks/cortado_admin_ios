import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/category.dart';

class CoffeeShop {
  final String id;
  final String name;
  final Map<dynamic, dynamic> address;
  final List<dynamic> blackCoffees;
  final String createdAt;
  final String updatedAt;
  final String description;
  final String disabledReason;
  final String picture;
  final Map hours;
  final Map hoursDaily;
  final String phone;
  final List<String> premiumCoffees;
  final DocumentReference reference;
  final List<dynamic> sizes;
  final List<dynamic> discounts;
  final String customStripeAccountId;
  final bool needsVerificationUpdate;
  final bool cortadoVerified;

  const CoffeeShop({
    this.reference,
    this.name,
    this.address,
    this.phone,
    this.hours,
    this.sizes,
    this.blackCoffees,
    this.cortadoVerified,
    this.createdAt,
    this.description,
    this.hoursDaily,
    this.disabledReason,
    this.premiumCoffees,
    this.updatedAt,
    this.needsVerificationUpdate,
    this.customStripeAccountId,
    this.discounts,
    this.picture,
    this.id,
  });

  CoffeeShop copyWith(
      {String id,
      String name,
      Map<dynamic, dynamic> address,
      List<dynamic> blackCoffees,
      String createdAt,
      String updatedAt,
      String description,
      String disabledReason,
      bool cortadoVerified,
      String picture,
      Map hours,
      Map hoursDaily,
      String phone,
      List<String> premiumCoffees,
      DocumentReference reference,
      List<Category> addIns,
      List<Category> drinks,
      List<Category> food,
      List<dynamic> sizes,
      List<dynamic> discounts,
      String customStripeAccountId,
      bool needsVerificationUpdate}) {
    return CoffeeShop(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        name: name ?? this.name,
        cortadoVerified: cortadoVerified ?? this.cortadoVerified,
        address: address ?? this.address,
        hours: hours ?? this.hours,
        hoursDaily: hoursDaily ?? this.hoursDaily,
        sizes: sizes ?? this.sizes,
        blackCoffees: blackCoffees ?? this.blackCoffees,
        createdAt: createdAt ?? this.createdAt,
        description: description ?? this.description,
        disabledReason: disabledReason ?? this.disabledReason,
        premiumCoffees: premiumCoffees ?? this.premiumCoffees,
        updatedAt: updatedAt ?? this.updatedAt,
        needsVerificationUpdate:
            needsVerificationUpdate ?? this.needsVerificationUpdate,
        customStripeAccountId:
            customStripeAccountId ?? this.customStripeAccountId,
        discounts: discounts ?? this.discounts,
        picture: picture ?? this.picture,
        phone: phone ?? this.phone);
  }

  CoffeeShop copy(CoffeeShop coffeeShop) {
    return CoffeeShop(
        id: coffeeShop.id ?? this.id,
        reference: coffeeShop.reference ?? this.reference,
        name: coffeeShop.name ?? this.name,
        address: coffeeShop.address ?? this.address,
        hours: coffeeShop.hours ?? this.hours,
        sizes: coffeeShop.sizes ?? this.sizes,
        hoursDaily: coffeeShop.hoursDaily ?? this.hoursDaily,
        cortadoVerified: coffeeShop.cortadoVerified ?? this.cortadoVerified,
        blackCoffees: coffeeShop.blackCoffees ?? this.blackCoffees,
        createdAt: coffeeShop.createdAt ?? this.createdAt,
        description: coffeeShop.description ?? this.description,
        disabledReason: coffeeShop.disabledReason ?? this.disabledReason,
        premiumCoffees: coffeeShop.premiumCoffees ?? this.premiumCoffees,
        updatedAt: coffeeShop.updatedAt ?? this.updatedAt,
        needsVerificationUpdate:
            coffeeShop.needsVerificationUpdate ?? this.needsVerificationUpdate,
        customStripeAccountId:
            coffeeShop.customStripeAccountId ?? this.customStripeAccountId,
        discounts: coffeeShop.discounts ?? this.discounts,
        picture: coffeeShop.picture ?? this.picture,
        phone: coffeeShop.phone ?? this.phone);
  }

  CoffeeShop.fromSnapshot(dynamic snapshot)
      : this.fromData(snapshot.data(), reference: snapshot.reference);

  /// Empty user which represents an uninitialized coffee Shop.
  static const empty = const CoffeeShop();

  CoffeeShop.fromData(Map<dynamic, dynamic> data, {this.reference})
      : this.id = reference.id,
        this.name = data['name'],
        this.sizes = data['sizes'],
        this.cortadoVerified = data['cortadoVerified'] ?? false,
        this.hoursDaily = data['hoursDaily'],
        this.customStripeAccountId = data["customStripeAccountId"],
        this.discounts = data['discounts'] ?? [],
        this.address = data['address'],
        this.needsVerificationUpdate = data['needsVerificationUpdate'] ?? true,
        this.blackCoffees = List<String>.from(data['blackCoffees'] ?? []),
        this.createdAt = data['createdAt'],
        this.updatedAt = data['updatedAt'],
        this.description = data['description'],
        this.disabledReason = data['disabledReason'],
        this.hours = data['hours'],
        this.phone = data['phone'],
        this.picture = data['picture'],
        this.premiumCoffees = List<String>.from(data['premiumCoffees'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'hours': hours,
      'hoursDaily': hoursDaily,
      'sizes': sizes,
      'cortadoVerified': cortadoVerified,
      'needsVerificationUpdate': needsVerificationUpdate,
      'customStripeAccountId': customStripeAccountId,
      'discounts': discounts,
      'blackCoffees': blackCoffees,
      'createdAt': createdAt,
      'description': description,
      'disabledReason': disabledReason,
      'premiumCoffees': premiumCoffees,
      'updatedAt': updatedAt,
      'picture': picture
    };
  }
}


