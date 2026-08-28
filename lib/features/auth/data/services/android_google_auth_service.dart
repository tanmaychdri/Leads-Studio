import 'package:google_sign_in/google_sign_in.dart';
import 'package:leads_studio/features/auth/data/models/app_user.dart';
import 'package:leads_studio/features/auth/data/services/auth_service.dart';

class AndroidGoogleAuthService implements AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      // Attempt to sign in silently if a previous session exists
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        return AppUser(
          id: account.id,
          email: account.email,
          displayName: account.displayName,
          photoUrl: account.photoUrl,
        );
      }
    } catch (e) {
      // Silent sign-in failed, not an error just means user needs to log in explicitly
    }
    return null;
  }

  @override
  Future<AppUser?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        return AppUser(
          id: account.id,
          email: account.email,
          displayName: account.displayName,
          photoUrl: account.photoUrl,
        );
      }
    } catch (e) {
      // Re-throw or handle error appropriately in the provider
      throw Exception('Failed to sign in with Google: $e');
    }
    return null;
  }

  @override
  Future<String?> getAccessToken() async {
    final account = _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    if (account != null) {
      final auth = await account.authentication;
      return auth.accessToken;
    }
    return null;
  }

  @override
  Future<bool> requestScopes(List<String> scopes) async {
    return await _googleSignIn.requestScopes(scopes);
  }
  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

