import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/daily_metrics.dart';
import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_sales_bar_chart.dart';
import 'package:tuple/tuple.dart';

class StatisticsService {
  final FirebaseFirestore _firestore;
  StatisticsService(this._firestore);

  CollectionReference get _metricsCollection => _firestore.collection("orders");

  Future<List<DailyMetrics>> getDailyMetrics(
      String coffeeShopId, List<String> days) async {
    List<DailyMetrics> dailyMetrics = [];
    for (String day in days) {
      DocumentSnapshot snap = await _metricsCollection
          .doc(coffeeShopId)
          .collection('metrics')
          .doc(day)
          .get();
      if (snap.exists)
        dailyMetrics.add(DailyMetrics.fromData(snap.data()));
      else
        dailyMetrics.add(DailyMetrics.empty);
    }

    return dailyMetrics;
  }

  List<DailySales> weeklySales(List<Tuple2<String, List<Order>>> weeklyOrders) {
    List<DailySales> weeklySales = [];

    weeklyOrders.forEach((tuple) {
      double amount = 0.00;
      tuple.item2.forEach((order) {
        double ordertotal = double.parse(order.total);
        amount += ordertotal;
      });

      weeklySales.add(DailySales(tuple.item1, amount));
    });

    return weeklySales;
  }
}
