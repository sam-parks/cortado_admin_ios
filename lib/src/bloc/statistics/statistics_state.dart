part of 'statistics_bloc.dart';

enum StatisticsStatus { loading, initialized }

@CopyWith()
class StatisticsState extends Equatable {
  const StatisticsState(
      {this.status = StatisticsStatus.loading,
      this.daysOfTheWeekIso = const [],
      this.weeklyUsers = const [],
      this.weeklySales = const []});

  final StatisticsStatus status;

  final List<String> daysOfTheWeekIso;

  final List<Series<DailyUsers, String>> weeklyUsers;
  final List<Series<DailySales, String>> weeklySales;

  @override
  List<Object> get props =>
      [status, daysOfTheWeekIso, weeklyUsers, weeklySales];
}
