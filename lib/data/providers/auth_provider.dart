import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../states/auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthInitial();
  }

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.length >= 6) {
      if (email == 'verify@example.com') {
         state = AuthUnverified(User(id: '3', email: email, username: 'VerifyMe'));
         return;
      }
      state = AuthAuthenticated(
        User(id: '1', email: email, username: 'User1'),
      );
    } else {
      state = const AuthError('Invalid email or password (min 6 chars)');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    String? birthDate,
  }) async {
    state = const AuthLoading();
    
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.contains('@') && password.length >= 6) {
      // Mock flow: After signup, account is unverified
      state = AuthUnverified(
        User(
          id: '2',
          email: email,
          username: username,
          birthDate: birthDate,
        ),
      );
    } else {
      state = const AuthError('Validation failed. Check your inputs.');
    }
  }

  Future<void> verifyEmail(String code) async {
    state = const AuthLoading();
    
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (code.length == 6) { 
      // Mock flow: Any 6-digit code succeeds for now
      state = const AuthInitial(); 
    } else {
      state = const AuthError('Please enter a valid 6-digit code.');
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AuthLoading();
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.contains('@')) {
      state = const AuthInitial();
    } else {
      state = const AuthError('Invalid email address');
    }
  }

  void signOut() {
    state = const AuthInitial();
  }
}
