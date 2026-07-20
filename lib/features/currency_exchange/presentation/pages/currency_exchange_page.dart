import 'package:flutter/material.dart';

class CurrencyExchangePage extends StatelessWidget {
  const CurrencyExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange Tracker'),
      ),
      body: const Center(
        child: Text('Currency Exchange Feature'),
      ),
    );
  }
}
