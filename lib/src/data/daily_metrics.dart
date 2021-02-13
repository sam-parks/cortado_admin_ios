import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMetrics {
  final double dailySales;
  final double dailyTips;
  final List<dynamic> dailyUsers;
  final List<dynamic> dailyUserRefs;
  final DateTime updatedAt;

  const DailyMetrics(
      {this.dailySales,
      this.dailyTips,
      this.dailyUsers,
      this.updatedAt,
      this.dailyUserRefs});

  DailyMetrics.fromData(
    Map<String, dynamic> data,
  )   : dailySales = data['dailySales'],
        dailyTips = (data['dailyTips'] as int).toDouble(),
        dailyUsers = data['dailyUsers'],
        dailyUserRefs = data['dailyUserRefs'],
        updatedAt = (data["updatedAt"] as Timestamp).toDate();
}
