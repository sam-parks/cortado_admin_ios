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
    List<String> weeklyUserEmails,
    List<Series<DailyUsers, String>> weeklyUsers,
  }) {
    return StatisticsState(
      daysOfTheWeekIso: daysOfTheWeekIso ?? this.daysOfTheWeekIso,
      status: status ?? this.status,
      weeklySales: weeklySales ?? this.weeklySales,
      weeklyUserEmails: weeklyUserEmails ?? this.weeklyUserEmails,
      weeklyUsers: weeklyUsers ?? this.weeklyUsers,
    );
  }
}
