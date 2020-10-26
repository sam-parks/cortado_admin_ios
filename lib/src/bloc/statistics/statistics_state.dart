part of 'statistics_bloc.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class UsersPerDayRetrieved extends StatisticsState {
  final List<Series<DailyUsers, String>> series;

  UsersPerDayRetrieved(this.series);
}
