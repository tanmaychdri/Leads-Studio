import 'package:leads_studio/features/auth/data/models/app_user.dart';

abstract class AuthService {
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> signIn();
  Future<void> signOut();
  Future<String?> getAccessToken();
  
  /// Requests additional OAuth scopes (e.g. for Google Drive).
  /// Returns true if successful.
  Future<bool> requestScopes(List<String> scopes);
}
