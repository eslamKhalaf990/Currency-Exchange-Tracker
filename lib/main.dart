import 'package:currency_exchange_tracker/core/di/di.dart' as di;
import 'package:currency_exchange_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/currency_exchange/presentation/bloc/rates_list_bloc.dart';
import 'features/currency_exchange/presentation/pages/currency_exchange_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => di.sl<RatesListBloc>(),
        child: const CurrencyExchangePage(),
      ),
    );
  }
}
