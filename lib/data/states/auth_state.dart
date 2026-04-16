import '../models/user_model.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthUnverified extends AuthState {
  final User user;
  const AuthUnverified(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
