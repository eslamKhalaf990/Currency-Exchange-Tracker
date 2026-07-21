import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_exchange_tracker/core/usecases/usecase.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/usecases/get_exchange_rates_usecase.dart';

part 'rates_list_event.dart';
part 'rates_list_state.dart';

class RatesListBloc extends Bloc<RatesListEvent, RatesListState> {
  final GetExchangeRatesUseCase getExchangeRatesUseCase;

  RatesListBloc({required this.getExchangeRatesUseCase}) : super(RatesListInitial()) {
    on<GetRatesListEvent>(_onGetRatesList);
  }

  Future<void> _onGetRatesList(
    GetRatesListEvent event,
    Emitter<RatesListState> emit,
  ) async {
    emit(RatesListLoading());
    final failureOrRates = await getExchangeRatesUseCase(NoParams());
    failureOrRates.fold(
      (failure) => emit(RatesListError(failure.message)),
      (rates) => emit(RatesListLoaded(rates)),
    );
  }
}
