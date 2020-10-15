import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/services/firebase_service.dart';

import 'bloc.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  UserManagementBloc() : super(null);

  @override
  Stream<UserManagementState> mapEventToState(
    UserManagementEvent event,
  ) async* {
    if (event is CreateBarista) {
      yield UserManagementLoadingState();
      bool success = await createBarista(event.firstName, event.lastName,
          event.email, event.password, event.coffeeShopId);
      if (success) {
        yield BaristaCreated();
      } else {
        yield UserManagementErrorState();
      }
    }

    if (event is RetrieveBaristas) {
      yield UserManagementLoadingState();
      List<CortadoUser> baristas = await retrieveBaristas(event.coffeeShopId);
      yield BaristasRetrieved(baristas);
    }
  }
}
