import 'package:currency_exchange_tracker/core/di/di.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/bloc/currency_detail_bloc.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/currency_detail_header.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/currency_history_chart.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/currency_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyDetailScreen extends StatelessWidget {
  final String currencyCode;

  const CurrencyDetailScreen({super.key, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CurrencyDetailBloc>()..add(GetCurrencyHistoryEvent(currencyCode)),
      child: Scaffold(
        appBar: AppBar(title: Text('${currencyCode.toUpperCase()} Details')),
        body: BlocBuilder<CurrencyDetailBloc, CurrencyDetailState>(
          builder: (context, state) {
            if (state is CurrencyDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CurrencyDetailLoaded) {
              final history = state.history;
              final currentRate = history.first.rates[currencyCode] ?? 0.0;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurrencyDetailHeader(
                      currencyCode: currencyCode,
                      currentRate: currentRate,
                    ),
                    const SizedBox(height: 32),
                    CurrencyHistoryChart(
                      history: history,
                      currencyCode: currencyCode,
                    ),
                    const SizedBox(height: 32),
                    CurrencyHistoryList(
                      history: history,
                      currencyCode: currencyCode,
                    ),
                  ],
                ),
              );
            } else if (state is CurrencyDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
