import 'package:cortado_admin_ios/src/data/custom_account.dart';

abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {}

class CustomAccountCreated extends PaymentState {}

class CustomAccountLinkCreated extends PaymentState {
  final String url;

  CustomAccountLinkCreated(this.url);
}

class CustomAccountRetrieved extends PaymentState {
  final CustomAccount customAccount;

  CustomAccountRetrieved(this.customAccount);
}

class PaymentLoadingState extends PaymentState {}
