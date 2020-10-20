import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:equatable/equatable.dart';

abstract class BaristaManagementState extends Equatable {
  const BaristaManagementState();

  @override
  List<Object> get props => [];
}

class BaristasLoadInProgress extends BaristaManagementState {}

class BaristasLoadSuccess extends BaristaManagementState {
  final List<CortadoUser> baristas;

  const BaristasLoadSuccess([this.baristas = const []]);

  @override
  List<Object> get props => [baristas];

  @override
  String toString() => 'BaristasLoadSuccess { baristas: $baristas }';
}

class BaristasLoadFailure extends BaristaManagementState {}
