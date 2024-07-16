part of 'order_history_bloc.dart';

abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object> get props => [];
}

class OrderHistoryFetchingEvent extends OrderHistoryEvent {}

class OrderDetailsFetchingEvent extends OrderHistoryEvent {}

class FetchOrderDetailsEvent extends OrderHistoryEvent {
  final String orderId;

  const FetchOrderDetailsEvent({required this.orderId});
}
