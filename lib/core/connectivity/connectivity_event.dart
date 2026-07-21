part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChangedEvent extends ConnectivityEvent {
  final bool isConnected;

  const ConnectivityChangedEvent(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class CheckConnectivityEvent extends ConnectivityEvent {}
