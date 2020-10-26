import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_users_bar_chart.dart';
import 'package:equatable/equatable.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsInitial());

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    if (event is RetrieveUsersPerDay) {}
  }
}
