part of 'finance_links_bloc.dart';

abstract class FinanceLinksEvent extends Equatable {
  const FinanceLinksEvent();

  @override
  List<Object> get props => [];
}

class CreateCustomAccountLink extends FinanceLinksEvent {
  final String account;

  CreateCustomAccountLink(this.account);
}

class CreateCustomAccountUpdateLink extends FinanceLinksEvent {
  final String account;

  CreateCustomAccountUpdateLink(this.account);
}
