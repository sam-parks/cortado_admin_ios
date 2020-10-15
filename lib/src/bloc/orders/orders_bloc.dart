import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/orders/bloc.dart';
import 'package:cortado_admin_ios/src/data/order.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/order_service.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrderService get _orderService => locator.get();

  OrdersBloc() : super(null);

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetOrders) {
      List<Order> orders;
      yield OrdersLoadingState();
      orders = await _orderService.ordersForShop(event.coffeeShop);
      yield OrdersRetrieved(orders);
    }

    if (event is StartOrder) {
      await _orderService.updateOrderStatus(
          OrderStatus.started, event.orderRef);
      yield OrderStarted(event.orderRef.id);
    }

    if (event is ReadyForPickup) {
      await _orderService.updateOrderStatus(
          OrderStatus.readyForPickup, event.orderRef);
      yield ReadyForPickupState(event.orderRef.id);
    }

    if (event is CompleteOrder) {
      await _orderService.updateOrderStatus(
          OrderStatus.completed, event.orderRef);
      yield OrderCompleted(event.orderRef.id);
    }
  }
}
