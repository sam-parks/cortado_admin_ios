import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/data/custom_account.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:cortado_admin_ios/src/services/stripe_service.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc({@required this.coffeeShopBloc}) : super(FinanceState.inital()) {
    _coffeeShopStateSubscription = coffeeShopBloc.listen((coffeeShopState) {
      if (coffeeShopState.status == CoffeeShopStatus.initialized) {
        String customAccountId =
            coffeeShopState.coffeeShop.customStripeAccountId;
        if (customAccountId != null && customAccountId != '')
          this.add(RetrieveCustomAccount(customAccountId));
      }

      if (coffeeShopState.status == CoffeeShopStatus.uninitialized) {
        this.add(UninitializeFinance());
      }
    });
  }

  final CoffeeShopBloc coffeeShopBloc;
  StreamSubscription _coffeeShopStateSubscription;

  StripeService get stripeService => locator.get();
  CoffeeShopService get coffeeShopService => locator.get();

  @override
  Stream<FinanceState> mapEventToState(
    FinanceEvent event,
  ) async* {
    if (event is CreateCustomAccount) {
      yield FinanceState.loading();

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

      yield FinanceState.unverified();
    }

    if (event is RetrieveCustomAccount) {
      yield FinanceState.loading();
      CustomAccount customAccount =
          await stripeService.retrieveCustomAccount(event.account);

      if (customAccount.requirements.currentlyDue.isNotEmpty) {
        print(customAccount.id + " is not verified yet");
        print("Currently due:" + customAccount.requirements.currentlyDue[0]);
        yield FinanceState.unverified(customAccount: customAccount);
      } else {
        yield FinanceState.verified(customAccount);
      }
    }

    if (event is UninitializeFinance) {
      yield FinanceState.inital();
    }
  }

  @override
  Future<void> close() {
    _coffeeShopStateSubscription.cancel();
    return super.close();
  }
}
