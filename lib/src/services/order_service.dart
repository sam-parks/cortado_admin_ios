import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/order.dart';

class OrderService {
  final FirebaseFirestore _firestore;
  OrderService(this._firestore);

  CollectionReference get _ordersCollection => _firestore.collection("orders");

  Future<List<Order>> ordersForShop(DocumentReference coffeeShop) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<Order> orders = [];
    QuerySnapshot query = await _ordersCollection
        .where('coffeeShop', isEqualTo: coffeeShop, isGreaterThan: today)
        .get();
    var remoteSnapshots = query.docs;
    for (var orderSnap in remoteSnapshots) {
      Order order = Order.fromSnap(orderSnap.data());
      order.orderRef = orderSnap.reference;

      orders.add(order);
    }
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  Future<void> updateOrderStatus(
      OrderStatus status, DocumentReference orderRef) {
    return orderRef.update({'status': status.statusToString()});
  }
}
