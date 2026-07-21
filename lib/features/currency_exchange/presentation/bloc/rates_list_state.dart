part of 'rates_list_bloc.dart';

abstract class RatesListState extends Equatable {
  const RatesListState();

  @override
  List<Object> get props => [];
}

class RatesListInitial extends RatesListState {}

class RatesListLoading extends RatesListState {}

class RatesListLoaded extends RatesListState {
  final List<CurrencyExchange> rates;

  const RatesListLoaded(this.rates);

  @override
  List<Object> get props => [rates];
}

class RatesListError extends RatesListState {
  final String message;

  const RatesListError(this.message);

  @override
  List<Object> get props => [message];
}
