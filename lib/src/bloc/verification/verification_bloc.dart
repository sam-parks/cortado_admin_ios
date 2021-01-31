import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationState.unverified(''));

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
