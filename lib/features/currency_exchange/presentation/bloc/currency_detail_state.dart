part of 'currency_detail_bloc.dart';

abstract class CurrencyDetailState extends Equatable {
  const CurrencyDetailState();

  @override
  List<Object> get props => [];
}

class CurrencyDetailInitial extends CurrencyDetailState {}

class CurrencyDetailLoading extends CurrencyDetailState {}

class CurrencyDetailLoaded extends CurrencyDetailState {
  final List<CurrencyExchange> history;

  const CurrencyDetailLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class CurrencyDetailError extends CurrencyDetailState {
  final String message;

  const CurrencyDetailError(this.message);

  @override
  List<Object> get props => [message];
}
