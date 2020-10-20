part of 'finance_links_bloc.dart';


abstract class FinanceLinksState extends Equatable {
  const FinanceLinksState();

  @override
  List<Object> get props => [];
}

class FinanceLinksLoading extends FinanceLinksState {}

class FinanceLinksInitial extends FinanceLinksState {}

class CustomAccountLinkCreated extends FinanceLinksState {
  final String link;

  const CustomAccountLinkCreated(this.link);

  @override
  List<Object> get props => [link];
}

class CustomUpdateLinkCreated extends FinanceLinksState {
  final String link;

  const CustomUpdateLinkCreated(this.link);

  @override
  List<Object> get props => [link];
}
