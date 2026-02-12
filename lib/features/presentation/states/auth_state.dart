abstract class AuthState {
  const AuthState();
  
  // Add this getter
  bool get isAuthenticated => this is AuthAuthenticated;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
}