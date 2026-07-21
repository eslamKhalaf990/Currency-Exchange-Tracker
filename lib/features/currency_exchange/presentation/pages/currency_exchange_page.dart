import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/bloc/rates_list_bloc.dart';

class CurrencyExchangePage extends StatelessWidget {
  const CurrencyExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            return RefreshIndicator(
              onRefresh: () async => context.read<RatesListBloc>().add(GetRatesListEvent()),
              child: ListView.builder(
                itemCount: state.rates.length,
                itemBuilder: (context, index) {
                  final currencyExchange = state.rates[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ExpansionTile(
                      title: Text(
                        'Rates for ${currencyExchange.date}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: currencyExchange.rates.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key.toUpperCase()),
                          trailing: Text(
                            '1 ${entry.key.toUpperCase()} = ${entry.value.toStringAsFixed(2)} EGP',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            );
          } else if (state is RatesListError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
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
