part of 'finance_bloc.dart';

enum FinanceStatus { initial, unverified, verified, loading }

class FinanceState extends Equatable {
  const FinanceState._(
      {this.status = FinanceStatus.initial,
      this.customAccount = CustomAccount.empty});

  const FinanceState.inital() : this._();

  const FinanceState.unverified() : this._(status: FinanceStatus.unverified);

  const FinanceState.loading() : this._(status: FinanceStatus.loading);

  const FinanceState.verified(CustomAccount customAccount)
      : this._(status: FinanceStatus.verified, customAccount: customAccount);

  final FinanceStatus status;
  final CustomAccount customAccount;

  @override
  List<Object> get props => [status, customAccount];
}

