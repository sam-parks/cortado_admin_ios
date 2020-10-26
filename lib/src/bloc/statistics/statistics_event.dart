part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class RetrieveUsersPerDay extends StatisticsEvent {
  final DocumentReference coffeeShopRef;

  RetrieveUsersPerDay(this.coffeeShopRef);
}

