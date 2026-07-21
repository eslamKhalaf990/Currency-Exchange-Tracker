import 'dart:async';
import 'package:currency_exchange_tracker/core/util/dev_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:currency_exchange_tracker/core/network/network_info.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final NetworkInfo networkInfo;
  StreamSubscription? _subscription;

  ConnectivityBloc({required this.networkInfo}) : super(ConnectivityInitial()) {
    on<ConnectivityChangedEvent>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });

    on<CheckConnectivityEvent>((event, emit) async {
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });

    _subscription = networkInfo.onConnectivityChanged.listen((isConnected) {
      add(ConnectivityChangedEvent(isConnected));
    });
    
    // Check initial state
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    add(ConnectivityChangedEvent(isConnected));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
