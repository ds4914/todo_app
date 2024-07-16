part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class SignInRequiredEvent extends SignInEvent{
  final String userName;
  final String password;
  final bool rememberMe;

  SignInRequiredEvent({required this.userName, required this.password, this.rememberMe = false});
}