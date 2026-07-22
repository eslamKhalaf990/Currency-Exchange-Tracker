import 'package:currency_exchange_tracker/core/connectivity/connectivity_bloc.dart';
import 'package:currency_exchange_tracker/core/util/date_formatter.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/currency_rate_card.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/offline_mode_banner.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/rates_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/bloc/rates_list_bloc.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/widgets/home_loader.dart';

class CurrencyExchangePage extends StatelessWidget {
  const CurrencyExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> allowedCurrencies = ['usd', 'eur', 'gbp', 'sar', 'jpy'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange Tracker'),
      ),
      body: BlocListener<ConnectivityBloc, ConnectivityState>(
        listenWhen: (previous, current) =>
            previous is ConnectivityOffline && current is ConnectivityOnline,
        listener: (context, state) {},
        child: Column(
          children: [
            BlocBuilder<ConnectivityBloc, ConnectivityState>(
              builder: (context, state) {
                if (state is ConnectivityOffline) {
                  return const OfflineModeBanner();
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<RatesListBloc, RatesListState>(
                builder: (context, state) {
                  if (state is RatesListInitial) {
                    context.read<RatesListBloc>().add(GetRatesListEvent());
                    return const Center(child: Text('Initializing...'));
                  } else if (state is RatesListLoading) {
                    return const HomeLoader();
                  } else if (state is RatesListLoaded) {
                    if (state.rates.isEmpty) {
                      return const Center(child: Text('No rates found.'));
                    }

                    // Assume index 0 is today and index 1 is yesterday as per RemoteDataSource
                    final today = state.rates[0];
                    final yesterday = state.rates.length > 1 ? state.rates[1] : null;

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<RatesListBloc>().add(GetRatesListEvent()),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Egyptian Pound Rates',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Last Updated At ${DateFormatter.formatString(today.date)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...allowedCurrencies.map((code) {
                            final rateToday = today.rates[code] ?? 0.0;
                            final rateYesterday = yesterday?.rates[code];

                            return CurrencyRateCard(
                              code: code,
                              rateToday: rateToday,
                              rateYesterday: rateYesterday,
                            );
                          }),
                          if (yesterday != null)
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Comparison based on rates from ${DateFormatter.formatString(yesterday.date)}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    );
                  } else if (state is RatesListError) {
                    return RatesErrorWidget(message: state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
