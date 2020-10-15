import 'package:cortado_admin_ios/src/data/cortado_user.dart';

abstract class UserManagementState {}

class UserManagementInitial extends UserManagementState {}

class BaristaCreated extends UserManagementState {}

class UserManagementLoadingState extends UserManagementState {}

class UserManagementErrorState extends UserManagementState {}

class BaristasRetrieved extends UserManagementState {
  final List<CortadoUser> baristas;

  BaristasRetrieved(this.baristas);
}
