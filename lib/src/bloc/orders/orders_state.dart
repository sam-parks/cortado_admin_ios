import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersRetrieved extends OrdersState {
  final List<Order> orders;

  OrdersRetrieved(this.orders);
}

class OrderStarted extends OrdersState {
  final String id;

  OrderStarted(this.id);
}

class OrderCompleted extends OrdersState {
  final String id;

  OrderCompleted(this.id);
}

class ReadyForPickupState extends OrdersState {
  final String id;

  ReadyForPickupState(this.id);
}
