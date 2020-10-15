import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/custom_account.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/services/stripe_service.dart';
import 'bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this.stripeService, this.coffeeShopService) : super(null);

  StripeService stripeService;
  CoffeeShopService coffeeShopService;

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    if (event is CreateCustomAccount) {
      yield PaymentLoadingState();
      CoffeeShop coffeeShop = event.coffeeShopState.coffeeShop;
      String account = await stripeService.createCustomAccount(
          event.businessEmail,
          event.accountHolderName,
          event.accountHolderType,
          event.routingNumber,
          event.accountNumber);
      coffeeShop.customStripeAccountId = account;
      await coffeeShopService.updateCoffeeShop(coffeeShop);
      event.coffeeShopState.update(coffeeShop);
      yield CustomAccountCreated();
    }

    if (event is CreateCustomAccountLink) {
      dynamic link = await stripeService.createCustomAccountLink(event.account);

      yield CustomAccountLinkCreated(link['url']);
    }

    if (event is CreateCustomAccountUpdateLink) {
      dynamic link =
          await stripeService.createCustomAccountUpdateLink(event.account);

      yield CustomAccountLinkCreated(link['url']);
    }

    if (event is RetrieveCustomAccount) {
      yield PaymentLoadingState();
      CustomAccount customAccount =
          await stripeService.retrieveCustomAccount(event.account);

      yield CustomAccountRetrieved(customAccount);
    }
  }
}
