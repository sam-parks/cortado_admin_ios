class DailyMetrics {
  final double dailySales;
  final double dailyTips;
  final List<dynamic> dailyUsers;
  final DateTime updatedAt;

  const DailyMetrics(
      {this.dailySales, this.dailyTips, this.dailyUsers, this.updatedAt});

  static const empty = const DailyMetrics(
      dailySales: 0.00, dailyTips: 0.00, dailyUsers: [], updatedAt: null);

  DailyMetrics.fromData(
    Map<String, dynamic> data,
  )   : dailySales = data['dailySales'],
        dailyTips = data['dailyTips'],
        dailyUsers = data['dailyUsers'],
        updatedAt = data["updatedAt"];
}
