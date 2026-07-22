import 'package:currency_exchange_tracker/features/currency_exchange/presentation/pages/currency_detail_screen.dart';
import 'package:flutter/material.dart';

class CurrencyRateCard extends StatelessWidget {
  final String code;
  final double rateToday;
  final double? rateYesterday;

  const CurrencyRateCard({
    super.key,
    required this.code,
    required this.rateToday,
    this.rateYesterday,
  });

  @override
  Widget build(BuildContext context) {
    final yesterdayValue = rateYesterday ?? rateToday;
    final absChange = rateToday - yesterdayValue;
    final pctChange = yesterdayValue != 0 ? (absChange / yesterdayValue) * 100 : 0.0;

    final Color changeColor = absChange > 0
        ? Colors.red
        : (absChange < 0 ? Colors.green : Colors.grey);

    final IconData changeIcon = absChange > 0
        ? Icons.trending_up
        : (absChange < 0 ? Icons.trending_down : Icons.trending_flat);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrencyDetailScreen(
                currencyCode: code,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  code[0].toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                    if (rateYesterday != null)
                      Text(
                        'Was ${rateYesterday!.toStringAsFixed(2)} EGP',
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
                      Icon(changeIcon, color: changeColor, size: 14),
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
      ),
    );
  }
}
