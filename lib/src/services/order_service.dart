import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class OrderService {
  OrderService._();
  static OrderService _instance = OrderService._();
  static OrderService get instance => _instance;

  final firestore = fb.firestore();

  CollectionReference get _ordersCollection => firestore.collection("orders");

  Future<List<Order>> ordersForShop(DocumentReference coffeeShop) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<Order> orders = [];
    QuerySnapshot query = await _ordersCollection
        .where('coffeeShop', "==", coffeeShop)
        .where('createdAt', ">", today)
        .get();
    var remoteSnapshots = query.docs;
    for (var orderSnap in remoteSnapshots) {
      Order order = Order.fromSnap(orderSnap.data());
      order.orderRef = orderSnap.ref;

      orders.add(order);
    }
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  Future<void> updateOrderStatus(
      OrderStatus status, DocumentReference orderRef) {
    return orderRef.update(data: {'status': status.statusToString()});
  }
}
