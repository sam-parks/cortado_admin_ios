part of 'verification_bloc.dart';

enum VerificationStatus { loading, unverified, verified, error }

class VerificationState extends Equatable {
  const VerificationState._(
      {this.status = VerificationStatus.unverified,
      this.code = '',
      this.error = ''});

  const VerificationState.loading()
      : this._(status: VerificationStatus.loading);

  const VerificationState.unverified()
      : this._(status: VerificationStatus.unverified);

  const VerificationState.verified()
      : this._(status: VerificationStatus.verified);

  const VerificationState.error(String error)
      : this._(status: VerificationStatus.error, error: error);

  final VerificationStatus status;
  final String code;
  final String error;

  @override
  List<Object> get props => [status, code, error];
}
