import 'package:firebase/firestore.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/item.dart';

class Order {
  DocumentReference orderRef;
  DocumentReference coffeeShop;
  DocumentReference customer;
  String customerName;
  DateTime createdAt;
  List<Drink> drinks = [];
  List<Food> food = [];
  String total;
  OrderStatus status;
  String orderNumber;

  Order(
      {this.orderRef,
      this.orderNumber,
      this.customerName,
      this.total,
      this.coffeeShop,
      this.createdAt,
      this.customer,
      this.drinks,
      this.food,
      this.status});

  Order.fromSnap(Map<dynamic, dynamic> json) {
    orderRef = json['orderRef'];
    orderNumber = json['orderNumber'];
    total = json['total'];
    coffeeShop = json['coffeeShop'];
    customer = json['customer'];
    customerName = json['customerName'];
    createdAt = json['createdAt'];
    json['drinks'] = json['drinks'] ?? [];
    drinks = List.generate(json['drinks'].length, (index) {
      Map<dynamic, dynamic> drinkMap = json['drinks'][index];

      print(drinkMap);

      return drinkMap != null ? drinkFromData(drinkMap) : [];
    });
    json['food'] = json['food'] ?? [];
    food = List.generate(json['food'].length, (index) {
      Map<dynamic, dynamic> foodMap = json['food'][index];

      return foodMap != null ? foodFromData(foodMap) : [];
    });
    status = getOrderStatusFromString(json['status']);
  }

  toJson() {
    return {
      'orderRef': orderRef,
      'orderNumber': orderNumber,
      'total': total,
      'coffeeShop': coffeeShop,
      'customer': customer,
      'customerName': customerName,
      'createdAt': createdAt,
      'drinks': drinks,
      'food': food,
      'status': status.statusToString(),
    };
  }

  getOrderStatusFromString(String status) {
    switch (status) {
      case "ordered":
        return OrderStatus.ordered;
        break;
      case "started":
        return OrderStatus.started;
        break;
      case "completed":
        return OrderStatus.completed;
        break;
      case "readyForPickup":
        return OrderStatus.readyForPickup;
        break;
      case "paid":
        return OrderStatus.paid;
        break;
      case "error":
        return OrderStatus.error;
        break;
      case "refunded":
        return OrderStatus.refunded;
        break;
      default:
        return OrderStatus.error;
    }
  }
}

enum OrderStatus {
  ordered,
  started,
  readyForPickup,
  completed,
  paid,
  error,
  refunded
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.ordered:
        return "ordered";
        break;
      case OrderStatus.started:
        return "started";
        break;
      case OrderStatus.readyForPickup:
        return "readyForPickup";
        break;
      case OrderStatus.completed:
        return "completed";
        break;
      case OrderStatus.paid:
        return "paid";
        break;
      case OrderStatus.error:
        return "error";
        break;
      case OrderStatus.refunded:
        return "refunded";
        break;
      default:
        return "error";
    }
  }

  statusToString() {
    return this.value;
  }
}
