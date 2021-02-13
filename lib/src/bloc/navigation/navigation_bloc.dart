import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc({@required this.authBloc}) : super(NavigationState.initial()) {
    _authStateSubscription = authBloc.listen((authState) {
      initDynamicLinks();
      if (authState.status == AuthStatus.authenticated &&
          this.state.navigationStatus != NavigationStatus.userTypeKnown) {
        this.add(InitializeUserType(authState.user.userType));
      }
      if (authState.status == AuthStatus.unauthenticated) {
        this.add(UninitializeUserType());
      }
    });
  }

  final AuthBloc authBloc;
  StreamSubscription _authStateSubscription;

  NavigationService get _navigationService => locator.get();

  @override
  Stream<NavigationState> mapEventToState(
    NavigationEvent event,
  ) async* {
    if (event is InitializeUserType) {
      List<MenuItem> menuItems = getMenuItems(event.userType);
      yield NavigationState.userTypeKnown(
          CortadoAdminScreen.dashboard, menuItems[0], menuItems);
    }

    if (event is UninitializeUserType) {
      yield NavigationState.initial();
    }

    if (event is ChangeDashboardPage) {
      _navigationService.pageController.jumpToPage(event.menuItem.index);
      CortadoAdminScreen updatedScreen =
          screenFromString(event.cortadoAdminScreen.name);
      yield NavigationState.userTypeKnown(
          updatedScreen, event.menuItem, state.menuItems);
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }

  List<MenuItem> getMenuItems(UserType userType) {
    switch (userType) {
      case UserType.barista:
        return baristaMenuItems;
        break;
      case UserType.owner:
        return ownerMenuItems;
        break;
      case UserType.superUser:
        return superUserMenuItems;
        break;
      default:
        return baristaMenuItems;
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {}
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {}
  }
}
