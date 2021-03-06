import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/barista_service.dart';
import 'bloc.dart';

class BaristaManagementBloc
    extends Bloc<BaristaManagementEvent, BaristaManagementState> {
  BaristaManagementBloc() : super(BaristasLoadInProgress());

  BaristaService get _baristaService => locator.get();

  @override
  Stream<BaristaManagementState> mapEventToState(
    BaristaManagementEvent event,
  ) async* {
    if (event is CreateBarista) {
      yield BaristasLoadInProgress();
      CortadoUser newBarista = await _baristaService.createBarista(
          event.firstName,
          event.lastName,
          event.phone,
          event.email,
          event.password,
          event.coffeeShopId);
      if (newBarista != null) {
        final List<CortadoUser> updatedTodos =
            List.from((state as BaristasLoadSuccess).baristas)..add(newBarista);
        yield BaristasLoadSuccess(updatedTodos);
      } else {
        yield BaristasLoadFailure();
      }
    }

    if (event is RetrieveBaristas) {
      yield BaristasLoadInProgress();
      List<CortadoUser> baristas =
          await _baristaService.retrieveBaristas(event.coffeeShopId);
      yield BaristasLoadSuccess(baristas);
    }
  }
}
