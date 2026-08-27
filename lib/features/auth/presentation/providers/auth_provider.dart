import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/auth/data/models/app_user.dart';
import 'package:leads_studio/features/auth/data/services/auth_service.dart';
import 'package:leads_studio/features/auth/data/services/android_google_auth_service.dart';
import 'package:leads_studio/features/auth/data/services/windows_google_auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  if (Platform.isWindows) {
    return WindowsGoogleAuthService();
  } else {
    return AndroidGoogleAuthService();
  }
});

class AuthState {
  final bool isLoading;
  final AppUser? user;
  final String? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, AppUser? user, String? error, bool clearError = false}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(isLoading: false, user: user, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.signIn();
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _authService.signOut();
      state = AuthState(); // Reset state completely on sign out
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
