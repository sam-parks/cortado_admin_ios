part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class InitializeStatistics extends StatisticsEvent {
  final DocumentReference coffeeShopRef;

  InitializeStatistics(this.coffeeShopRef);
}
