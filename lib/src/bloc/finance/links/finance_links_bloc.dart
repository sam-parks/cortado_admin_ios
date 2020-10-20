import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/stripe_service.dart';
import 'package:equatable/equatable.dart';

part 'finance_links_event.dart';
part 'finance_links_state.dart';

class FinanceLinksBloc extends Bloc<FinanceLinksEvent, FinanceLinksState> {
  FinanceLinksBloc() : super(FinanceLinksInitial());
  StripeService get stripeService => locator.get();

  @override
  Stream<FinanceLinksState> mapEventToState(
    FinanceLinksEvent event,
  ) async* {
    if (event is CreateCustomAccountLink) {
      yield FinanceLinksLoading();
      dynamic link = await stripeService.createCustomAccountLink(event.account);
      String verifyLink = link['url'];
      yield CustomAccountLinkCreated(verifyLink);
    }

    if (event is CreateCustomAccountUpdateLink) {
      yield FinanceLinksLoading();
      dynamic link =
          await stripeService.createCustomAccountUpdateLink(event.account);
      String loginLink = link['url'];
      yield CustomUpdateLinkCreated(loginLink);
    }
  }
}
