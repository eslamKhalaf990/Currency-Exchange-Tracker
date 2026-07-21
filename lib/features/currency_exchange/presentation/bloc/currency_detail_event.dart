part of 'currency_detail_bloc.dart';

abstract class CurrencyDetailEvent extends Equatable {
  const CurrencyDetailEvent();

  @override
  List<Object> get props => [];
}

class GetCurrencyHistoryEvent extends CurrencyDetailEvent {
  final String currencyCode;

  const GetCurrencyHistoryEvent(this.currencyCode);

  @override
  List<Object> get props => [currencyCode];
}
