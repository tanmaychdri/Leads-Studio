import 'package:leads_studio/features/auth/data/models/app_user.dart';

abstract class AuthService {
  /// Returns the current authenticated user, or null if unauthenticated.
  Future<AppUser?> getCurrentUser();

  /// Initiates the sign-in flow.
  Future<AppUser?> signIn();

  /// Signs the user out.
  Future<void> signOut();
}
