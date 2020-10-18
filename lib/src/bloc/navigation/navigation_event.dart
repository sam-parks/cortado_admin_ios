part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class InitializeUserType extends NavigationEvent {
  final UserType userType;

  InitializeUserType(this.userType);
}

class ChangeDashboardPage extends NavigationEvent {
  final CortadoAdminScreen cortadoAdminScreen;
  final MenuItem menuItem;

  ChangeDashboardPage(this.cortadoAdminScreen, this.menuItem);
}
