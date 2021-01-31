part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object> get props => [];
}

class CodeChanged extends VerificationEvent {
  final String code;

  CodeChanged(this.code);
}

class CodeCompleted extends VerificationEvent {
  final CoffeeShop coffeeShop;
  final String code;

  CodeCompleted(this.code, this.coffeeShop);
}

class SubmitCodeManually extends VerificationEvent {}
