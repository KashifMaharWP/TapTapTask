import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptap_task_kashif/features/presentation/states/auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    
    await Future.delayed(const Duration(seconds: 1));
    //debugger();
    if (email == 'admin@example.com' && password == 'password') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      emit(AuthAuthenticated());
    } else {
      emit(AuthError('Invalid credentials'));
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    emit(AuthUnauthenticated());
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }
}