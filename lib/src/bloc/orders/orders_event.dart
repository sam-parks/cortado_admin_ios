import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
abstract class OrdersEvent {}

class GetOrders extends OrdersEvent {
  final String coffeeShopName;

  GetOrders(this.coffeeShopName);
}

class StartOrder extends OrdersEvent {
  final DocumentReference orderRef;

  StartOrder(this.orderRef);
}

class ReadyForPickup extends OrdersEvent {
  final DocumentReference orderRef;

  ReadyForPickup(this.orderRef);
}

class CompleteOrder extends OrdersEvent {
  final DocumentReference orderRef;

  CompleteOrder(this.orderRef);
}

class ReadyOrder extends OrdersEvent {
  final DocumentReference orderRef;

  ReadyOrder(this.orderRef);
}
