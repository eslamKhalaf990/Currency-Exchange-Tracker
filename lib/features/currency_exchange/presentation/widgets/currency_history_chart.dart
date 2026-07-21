import 'package:currency_exchange_tracker/core/util/date_formatter.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CurrencyHistoryChart extends StatelessWidget {
  final List<CurrencyExchange> history;
  final String currencyCode;

  const CurrencyHistoryChart({
    super.key,
    required this.history,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final points = history.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final rate = entry.value.rates[currencyCode] ?? 0.0;
      return FlSpot(index, rate);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < history.length) {
                      final date = DateFormatter.formatChartDate(
                        history[index].date,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 30,
                          right: 30,
                        ),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor:
                    (touchedSpot) => Theme.of(context).colorScheme.primary,
                tooltipBorderRadius: BorderRadius.circular(100),
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final date = DateFormatter.formatString(
                      history[index].date,
                    );
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(2)} EGP\n',
                      TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: date,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: points,
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
