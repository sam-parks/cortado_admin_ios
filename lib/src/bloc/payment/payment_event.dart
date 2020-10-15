import 'package:cortado_admin_ios/src/data/models/coffee_shop_state.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class CreateCustomAccount extends PaymentEvent {
  final String businessEmail;
  final String accountHolderName;
  final String accountHolderType;
  final String routingNumber;
  final String accountNumber;
  final CoffeeShopState coffeeShopState;

  CreateCustomAccount(
    this.businessEmail,
    this.accountHolderName,
    this.accountHolderType,
    this.routingNumber,
    this.accountNumber,
    this.coffeeShopState,
  );
}

class CreateCustomAccountLink extends PaymentEvent {
  final String account;

  CreateCustomAccountLink(this.account);
}

class CreateCustomAccountUpdateLink extends PaymentEvent {
  final String account;

  CreateCustomAccountUpdateLink(this.account);
}

class RetrieveCustomAccount extends PaymentEvent {
  final String account;

  RetrieveCustomAccount(this.account);
}
