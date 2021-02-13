import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/order.dart';

class OrderService {
  final FirebaseFirestore _firestore;
  OrderService(this._firestore);

  CollectionReference get _ordersCollection => _firestore.collection("orders");

  StreamController<List<Order>> _ordersController = StreamController();

  Stream<List<Order>> get orders async* {
    yield* _ordersController.stream;
  }

  ordersForShop(DocumentReference coffeeShop) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    _ordersCollection
        .where('coffeeShop', isEqualTo: coffeeShop)
        .where('createdAt', isGreaterThan: today)
        .snapshots()
        .listen((query) {
      List<Order> orders = [];
      var remoteSnapshots = query.docs;
      for (var orderSnap in remoteSnapshots) {
        Order order = Order.fromSnap(orderSnap.data());
        order.orderRef = orderSnap.reference;

        orders.add(order);
      }
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _ordersController.add(orders);
    });
  }



  Future<void> updateOrderStatus(
      OrderStatus status, DocumentReference orderRef) {
    return orderRef.update({'status': status.statusToString()});
  }

  dispose() {
    _ordersController.close();
  }
}
