import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/custom_account.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/services/stripe_service.dart';
import 'bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this.coffeeShopBloc) : super(null);

  CoffeeShopBloc coffeeShopBloc;
  StripeService get stripeService => locator.get();
  CoffeeShopService get coffeeShopService => locator.get();

  @override
  Stream<PaymentState> mapEventToState(
    PaymentEvent event,
  ) async* {
    if (event is CreateCustomAccount) {
      yield PaymentLoadingState();
      CoffeeShop coffeeShop = event.coffeeShop;
      String account = await stripeService.createCustomAccount(
          event.businessEmail,
          event.accountHolderName,
          event.accountHolderType,
          event.routingNumber,
          event.accountNumber);
      CoffeeShop updatedCoffeeShop =
          coffeeShop.copyWith(customStripeAccountId: account);

      await coffeeShopService.updateCoffeeShop(updatedCoffeeShop);
      coffeeShopBloc.add(UpdateCoffeeShop(updatedCoffeeShop));
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
