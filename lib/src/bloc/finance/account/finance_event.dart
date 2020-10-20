part of 'finance_bloc.dart';

@immutable
abstract class FinanceEvent {}

class CreateCustomAccount extends FinanceEvent {
  final String businessEmail;
  final String accountHolderName;
  final String accountHolderType;
  final String routingNumber;
  final String accountNumber;
  final CoffeeShop coffeeShop;

  CreateCustomAccount(
    this.businessEmail,
    this.accountHolderName,
    this.accountHolderType,
    this.routingNumber,
    this.accountNumber,
    this.coffeeShop,
  );
}

class RetrieveCustomAccount extends FinanceEvent {
  final String account;

  RetrieveCustomAccount(this.account);
}
