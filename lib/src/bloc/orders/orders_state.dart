import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class OrdersState extends Equatable {
  final List<Order> orders;

  OrdersState(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrdersInitial extends OrdersState {
  OrdersInitial() : super(const []);

  @override
  List<Object> get props => throw UnimplementedError();
}

class OrdersLoadingState extends OrdersState {
  OrdersLoadingState(List<Order> orders) : super(orders);
}

class OrdersRetrieved extends OrdersState {
  final List<Order> orders;

  OrdersRetrieved(this.orders) : super(orders);
}

class OrderStarted extends OrdersState {
  final String id;
  final List<Order> orders;

  OrderStarted(
    this.id,
    this.orders,
  ) : super(null);
}

class OrderCompleted extends OrdersState {
  final String id;
  final List<Order> orders;

  OrderCompleted(this.id, this.orders) : super(orders);
}

class ReadyForPickupState extends OrdersState {
  final String id;
  final List<Order> orders;

  ReadyForPickupState(this.id, this.orders) : super(orders);
}
