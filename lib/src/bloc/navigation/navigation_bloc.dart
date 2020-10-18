import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/services/navigation_service.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState.initial());

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

    if (event is ChangeDashboardPage) {
      _navigationService.pageController
          .jumpToPage(event.cortadoAdminScreen.index);
      CortadoAdminScreen updatedScreen =
          screenFromString(event.cortadoAdminScreen.name);
      yield NavigationState.userTypeKnown(
          updatedScreen, event.menuItem, state.menuItems);
    }
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
}
