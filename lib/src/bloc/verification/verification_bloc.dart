import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/coffee_shop_service.dart';
import 'package:equatable/equatable.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationState.unverified());

  CoffeeShopService get _coffeeShopService => locator.get();

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    if (event is CodeChanged) {
      yield VerificationState.unverified();
    } else if (event is CodeCompleted) {
      yield VerificationState.loading();

      bool success =
          await _coffeeShopService.verify(event.code, event.coffeeShop.id);

      Future.delayed(Duration(seconds: 2));

      if (success) {
        CoffeeShop updatedShop =
            event.coffeeShop.copyWith(cortadoVerified: true);

       await _coffeeShopService.updateCoffeeShop(updatedShop);
        yield VerificationState.verified();
      } else {
        yield VerificationState.error(
            "We're sorry, that verification code does not seem to be correct. Please reachout to Info@cortadoapp.com to recieve a new code.");
      }
    }
  }
}
