import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsService {
  final FirebaseFirestore _firestore;
  StatisticsService(this._firestore);

  CollectionReference get _ordersCollection => _firestore.collection("orders");

  CollectionReference get _usersCollection => _firestore.collection('users');

  retrieveOrdersPerDay(DocumentReference coffeeShopRef) {
    coffeeShopRef.collection('orders');
  }
}
