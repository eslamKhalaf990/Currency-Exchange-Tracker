import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_exchange_tracker/core/usecases/usecase.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/usecases/get_historical_rates_usecase.dart';

part 'currency_detail_event.dart';
part 'currency_detail_state.dart';

class CurrencyDetailBloc extends Bloc<CurrencyDetailEvent, CurrencyDetailState> {
  final GetHistoricalRatesUseCase getHistoricalRatesUseCase;

  CurrencyDetailBloc({required this.getHistoricalRatesUseCase})
      : super(CurrencyDetailInitial()) {
    on<GetCurrencyHistoryEvent>(_onGetCurrencyHistory);
  }

  Future<void> _onGetCurrencyHistory(
    GetCurrencyHistoryEvent event,
    Emitter<CurrencyDetailState> emit,
  ) async {
    emit(CurrencyDetailLoading());
    final failureOrRates = await getHistoricalRatesUseCase(NoParams());
    failureOrRates.fold(
      (failure) => emit(CurrencyDetailError(failure.message)),
      (rates) => emit(CurrencyDetailLoaded(rates)),
    );
  }
}
