import 'package:currency_exchange_tracker/core/util/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/bloc/rates_list_bloc.dart';

class CurrencyExchangePage extends StatelessWidget {
  const CurrencyExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> allowedCurrencies = ['usd', 'eur', 'gbp', 'sar', 'jpy'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange Tracker'),
      ),
      body: BlocBuilder<RatesListBloc, RatesListState>(
        builder: (context, state) {
          if (state is RatesListInitial) {
            context.read<RatesListBloc>().add(GetRatesListEvent());
            return const Center(child: Text('Initializing...'));
          } else if (state is RatesListLoading) {
            return const Center(child: CircularProgressIndicator());
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
                    final rateYesterday = yesterday?.rates[code] ?? rateToday;

                    final absChange = rateToday - rateYesterday;
                    final pctChange = rateYesterday != 0
                        ? (absChange / rateYesterday) * 100
                        : 0.0;

                    // Color: Green if rate decreased (EGP improved), Red if rate increased (EGP weakened)
                    final Color changeColor = absChange > 0
                        ? Colors.red
                        : (absChange < 0 ? Colors.green : Colors.grey);

                    final IconData changeIcon = absChange > 0
                        ? Icons.trending_up
                        : (absChange < 0
                            ? Icons.trending_down
                            : Icons.trending_flat);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                              child: Text(
                                code[0].toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    code.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  if (yesterday != null)
                                    Text(
                                      'Was ${rateYesterday.toStringAsFixed(2)} EGP',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${rateToday.toStringAsFixed(2)} EGP',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(changeIcon,
                                        color: changeColor, size: 14),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${absChange.abs().toStringAsFixed(2)} (${pctChange.abs().toStringAsFixed(2)}%)',
                                      style: TextStyle(
                                        color: changeColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<RatesListBloc>().add(GetRatesListEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
