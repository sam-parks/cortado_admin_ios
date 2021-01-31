part of 'verification_bloc.dart';

enum VerificationStatus { loading, unverified, verified, error }

class VerificationState extends Equatable {
  const VerificationState._(
      {this.status = VerificationStatus.unverified,
      this.code = '',
      this.error = ''});

  const VerificationState.loading()
      : this._(status: VerificationStatus.loading);

  const VerificationState.unverified(String code)
      : this._(status: VerificationStatus.unverified, code: code);

  const VerificationState.verified(String code)
      : this._(status: VerificationStatus.verified, code: code);

  const VerificationState.error(String code, String error)
      : this._(status: VerificationStatus.error, error: error, code: code);

  final VerificationStatus status;
  final String code;
  final String error;

  @override
  List<Object> get props => [];
}
