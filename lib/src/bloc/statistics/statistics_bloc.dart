import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/data/daily_metrics.dart';
import 'package:cortado_admin_ios/src/services/statistics_service.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_sales_bar_chart.dart';
import 'package:cortado_admin_ios/src/ui/widgets/charts/daily_users_bar_chart.dart';
import 'package:cortado_admin_ios/src/utils/date_time_util.dart';
import 'package:equatable/equatable.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';
part 'statistics_bloc.g.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({@required this.coffeeShopBloc}) : super(StatisticsState()) {
    _coffeeShopStateSubscription = coffeeShopBloc.listen((coffeeShopState) {
      if (coffeeShopState.status == CoffeeShopStatus.initialized) {
        this.add(InitializeStatistics(coffeeShopState.coffeeShop.reference));
      }
    });
  }
  final CoffeeShopBloc coffeeShopBloc;
  StreamSubscription _coffeeShopStateSubscription;
  StatisticsService get _statisticsService => locator.get();

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    if (event is InitializeStatistics) {
      yield await _mapInitializeStatisticsToState(event);
    }
  }

  Future<StatisticsState> _mapInitializeStatisticsToState(
      InitializeStatistics event) async {
    List<String> daysOfTheWeek = [];

    DateTime today = DateTime.now();
    DateTime todayWithoutHours = DateTime(today.year, today.month, today.day);
    DateTime beginningOfWeek =
        DateTimeUtil.findFirstDateOfTheWeek(todayWithoutHours);

    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      daysOfTheWeek
          .add(beginningOfWeek.add(Duration(days: i)).toIso8601String() + 'Z');
    }

    List<Series<DailySales, String>> weeklySales = [];
    List<Series<DailyUsers, String>> weeklyUsers = [];
    List<String> weeklyUserEmails = [];

    List<DailyMetrics> dailyMetrics = await _statisticsService.getDailyMetrics(
        event.coffeeShopRef.id, daysOfTheWeek);

    final weeklySalesData = dailyMetrics
        .map((metric) => DailySales(
            DateFormat('dd MMM').format(metric.updatedAt), metric.dailySales))
        .toList();
    final weeklyUsersData = dailyMetrics
        .map((metric) => DailyUsers(
            DateFormat('dd MMM').format(metric.updatedAt),
            metric.dailyUsers.length))
        .toList();

    dailyMetrics.forEach((metric) {
      metric.dailyUsers.forEach((email) {
        if (!weeklyUserEmails.contains(email)) weeklyUserEmails.add(email);
      });
    });

    weeklySales = [
      charts.Series<DailySales, String>(
          id: 'Sales',
          domainFn: (DailySales dailySales, _) => dailySales.day,
          measureFn: (DailySales dailySales, _) => dailySales.amount,
          data: weeklySalesData,
          fillColorFn: (_, __) => charts.Color.fromHex(code: '#471D00'),
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DailySales dailySales, _) =>
              '\$${dailySales.amount.toString()}')
    ];

    weeklyUsers = [
      charts.Series<DailyUsers, String>(
          id: 'Sales',
          domainFn: (DailyUsers dailyUsers, _) => dailyUsers.day,
          measureFn: (DailyUsers dailyUsers, _) => dailyUsers.amount,
          data: weeklyUsersData,
          fillColorFn: (_, __) => charts.Color.fromHex(code: '#471D00'),
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DailyUsers dailyUsers, _) =>
              '\$${dailyUsers.amount.toString()}')
    ];

    return state.copyWith(
        status: StatisticsStatus.initialized,
        weeklySales: weeklySales,
        weeklyUserEmails: weeklyUserEmails,
        weeklyUsers: weeklyUsers);
  }

  @override
  Future<void> close() {
    _coffeeShopStateSubscription.cancel();
    return super.close();
  }
}
