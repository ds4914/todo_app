part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartScreenLoadingState extends CartState {}

class CartScreenLoadedState extends CartState {
  final List<CartModel> cartItems;

  CartScreenLoadedState({required this.cartItems});
}

class CartItemUpdateState extends CartState {
  final int id;

  CartItemUpdateState(this.id);
}

class CartItemCreatedState extends CartState {
  final int id;

  CartItemCreatedState(this.id);
}

class CartItemAddedOnClickedState extends CartState {
  final int id;

  CartItemAddedOnClickedState(this.id);
}

class CartItemAddedState extends CartState {
  final int id;

  CartItemAddedState(this.id);
}

class CartErrorState extends CartState {
  final String errorMessage;

  CartErrorState(this.errorMessage);
}

class CartItemDeleteState extends CartState {
  final int id;

  CartItemDeleteState(this.id);
}

// for search cart items
class CartItemSearchState extends CartState {
  CartItemSearchState({required this.items});

  final List<CartModel> items;
}

class SearchLoadingState extends CartState {}

class SearchError extends CartState {
  final String message;

  SearchError(this.message);
}