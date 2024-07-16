part of 'add_to_cart_bloc.dart';

@immutable
abstract class AddToCartState {}

class AddToCartInitial extends AddToCartState {}

class AddToCartLoadingState extends AddToCartState {}

class AddToCartItemAddedSuccessState extends AddToCartState {
  final List<CartItemModel> cartItems;
  final OfferState? offerState;

  AddToCartItemAddedSuccessState({required this.cartItems, this.offerState});
}

class ItemRemovedFromCartState extends AddToCartState {
  final int id;
  ItemRemovedFromCartState(this.id);
}

class CheckedItemsToPaymentScreenState extends AddToCartState {
  final List<CartItemModel> checkedItems;
  final OfferState? offerState;

  CheckedItemsToPaymentScreenState(this.checkedItems, this.offerState);
}

class AddToCartErrorState extends AddToCartState {
  final String message;

  AddToCartErrorState(this.message);
}

abstract class OfferState {}

class SBIState extends OfferState {
  final double discountPercentage = 0.03;
}

class AxisState extends OfferState {
  final double discountPercentage = 0.05;
}

class FirstTransactionState extends OfferState {
  final double discountPercentage = 0.02;
}

class OrderPlacedState extends AddToCartState {
  final String orderId;
  OrderPlacedState(this.orderId);
}