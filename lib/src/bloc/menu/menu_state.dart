import 'package:cortado_admin_ios/src/data/menu.dart';
import 'package:flutter/material.dart';

enum MenuStatus { initialized, loading, updated }

@immutable
class MenuState {
  const MenuState._({this.status, this.menu = Menu.empty});

  const MenuState.loading() : this._(status: MenuStatus.loading);

  const MenuState.initialized(menu)
      : this._(status: MenuStatus.initialized, menu: menu);

  final Menu menu;

  final MenuStatus status;
}
