import 'package:currency_exchange_tracker/core/util/date_formatter.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:flutter/material.dart';

class CurrencyHistoryList extends StatelessWidget {
  final List<CurrencyExchange> history;
  final String currencyCode;

  const CurrencyHistoryList({
    super.key,
    required this.history,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(30),
            ),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(DateFormatter.formatString(item.date)),
                trailing: Text(
                  '${item.rates[currencyCode]?.toStringAsFixed(2)} EGP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
