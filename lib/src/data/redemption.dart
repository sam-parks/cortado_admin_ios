import 'package:firebase/firestore.dart';
class Redemption {
  String type;
  String drinkTitle;
  DateTime createdAt;
  DocumentReference statement;
  DocumentReference customer;
  DocumentReference coffeeShop;

  Redemption(this.type, this.coffeeShop, this.createdAt, this.drinkTitle,
      this.statement, this.customer);

  Redemption.fromSnap(Map<dynamic, dynamic> json) {
    type = json['type'];
    drinkTitle = json['drinkTitle'];
    createdAt = json['createdAt'];
    statement = json['statement'];
    customer = json['customer'];
    coffeeShop = json['coffeeShop'];
  }
}
