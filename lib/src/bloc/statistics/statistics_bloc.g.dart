// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension StatisticsStateCopyWith on StatisticsState {
  StatisticsState copyWith({
    List<String> daysOfTheWeekIso,
    StatisticsStatus status,
    List<Series<DailySales, String>> weeklySales,
    List<Series<DailyUsers, String>> weeklyUsers,
    List<String> weeklyUserEmails,
  }) {
    return StatisticsState(
      daysOfTheWeekIso: daysOfTheWeekIso ?? this.daysOfTheWeekIso,
      status: status ?? this.status,
      weeklySales: weeklySales ?? this.weeklySales,
      weeklyUsers: weeklyUsers ?? this.weeklyUsers,
      weeklyUserEmails:weeklyUserEmails
    );
  }
}
