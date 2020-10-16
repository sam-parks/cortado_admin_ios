import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(this.dashboardContoller, menuItems)
      : super(NavigationInitial(
            CortadoAdminScreen.dashboard, menuItems[0], menuItems));

  final PageController dashboardContoller;

  @override
  Stream<NavigationState> mapEventToState(
    NavigationEvent event,
  ) async* {
    if (event is ChangeDashboardPage) {
      dashboardContoller.jumpToPage(event.cortadoAdminScreen.index);
      CortadoAdminScreen updatedScreen =
          screenFromString(event.cortadoAdminScreen.name);
      yield NavigationState(updatedScreen, event.menuItem, state.menuItems);
    }
  }
}
