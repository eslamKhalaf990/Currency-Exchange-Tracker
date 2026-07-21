part of 'rates_list_bloc.dart';

abstract class RatesListEvent extends Equatable {
  const RatesListEvent();

  @override
  List<Object> get props => [];
}

class GetRatesListEvent extends RatesListEvent {}
