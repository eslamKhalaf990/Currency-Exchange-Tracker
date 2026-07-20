import 'package:flutter/material.dart';
import 'features/currency_exchange/presentation/pages/currency_exchange_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF07CCA7)),
        useMaterial3: true,
      ),
      home: const CurrencyExchangePage(),
    );
  }
}
