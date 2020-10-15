import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/auth_service.dart';
import 'package:cortado_admin_ios/src/services/notification_service.dart';
import 'package:cortado_admin_ios/src/services/user_service.dart';
import 'package:cortado_admin_ios/src/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.unknown());

  AuthService get _authService => locator.get();
  UserService get _userService => locator.get();
  NotificationService get _notificationService => locator.get();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignInEmailPressed) {
      yield AuthState.loading();
      try {
        User firebaseUser =
            await _authService.signIn(event.email, event.password);
        if (firebaseUser == null) {
          yield AuthState.error(kEmailNotVerifiedError);
        } else {
          CortadoUser user = await _userService.getUser(firebaseUser);
          if (firebaseUser != null && user != null) {
            UserType userType = await getUserType(user);

            yield AuthState.authenticated(user.copyWith(userType: userType));
          } else {
            yield AuthState.error(kGenericSignInError);
          }
        }
      } catch (e) {
        print(e);
        if (e is PlatformException) {
          ///   • `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
          ///   • `ERROR_WRONG_PASSWORD` - If the [password] is wrong.
          ///   • `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
          ///   • `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
          ///   • `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
          ///   • `ERROR_OPERATION_NOT_ALLOWED`
          switch (e.code) {
            case 'ERROR_INVALID_EMAIL':
            case 'ERROR_WRONG_PASSWORD':
              yield AuthState.error(
                  "Cortado recently updated its security. Click here to reset your password.");
              break;
            case 'ERROR_USER_NOT_FOUND':
              yield AuthState.error(kWrongEmailPass);
              break;
            case 'ERROR_USER_DISABLED':
            case 'ERROR_TOO_MANY_REQUESTS':
              yield AuthState.error(kTooManyAttempts);
              break;
            default:
              yield AuthState.error(kGenericSignInError);
          }
        } else
          yield AuthState.error(e.toString());
      }
    }
    if (event is SignOut) {
      _notificationService.stop();
      await _authService.signOut();

      yield AuthState.unauthenticated();
    }
  }

  getUserType(CortadoUser user) async {
    try {
      if (user != null) {
        bool _cortadoFullAdmin = await _userService.checkCortadoFullAdmin(user);
        if (_cortadoFullAdmin) {
          return UserType.superUser;
        }
        bool _coffeeShopAdmin = await _userService.checkCoffeeShopAdmin(user);
        if (_coffeeShopAdmin) {
          return UserType.owner;
        }
        bool _barista = await _userService.checkBarista(user);
        if (_barista) {
          return UserType.barista;
        }
        throw 'Invalid User';
      }
    } catch (e) {
      throw 'Invalid User';
    }
  }
}
