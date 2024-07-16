part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class FetchOrderHistoryState extends OrderHistoryState {
  final List<Map<String, dynamic>> orderHistoryList;

  const FetchOrderHistoryState({required this.orderHistoryList});
}

class OrderHistoryLoadingError extends OrderHistoryState {
  final String message;

  const OrderHistoryLoadingError(this.message);
}

class OrderDetailsFetchingState extends OrderHistoryState {
  final List<Map<String, dynamic>> orderDetailsList;

  const OrderDetailsFetchingState({required this.orderDetailsList});
}
