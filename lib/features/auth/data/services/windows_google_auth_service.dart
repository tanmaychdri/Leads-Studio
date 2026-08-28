import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leads_studio/features/auth/data/models/app_user.dart';
import 'package:leads_studio/features/auth/data/services/auth_service.dart';

class WindowsGoogleAuthService implements AuthService {
  String get _clientId => dotenv.env['WINDOWS_CLIENT_ID'] ?? '';
  String get _clientSecret => dotenv.env['WINDOWS_CLIENT_SECRET'] ?? '';
  
  static const String _authUrl = 'https://accounts.google.com/o/oauth2/v2/auth';
  static const String _tokenUrl = 'https://oauth2.googleapis.com/token';
  static const String _userInfoUrl = 'https://www.googleapis.com/oauth2/v2/userinfo';
  static const String _redirectUri = 'http://localhost:8000';
  
  final _storage = const FlutterSecureStorage();

  @override
  Future<AppUser?> getCurrentUser() async {
    final token = await _storage.read(key: 'google_refresh_token');
    if (token == null) return null;

    try {
      final newAccessToken = await _refreshAccessToken(token);
      return await _fetchUserProfile(newAccessToken);
    } catch (e) {
      await _storage.delete(key: 'google_refresh_token');
      return null;
    }
  }

  @override
  Future<AppUser?> signIn() async {
    return await _performAuthFlow(scopes: 'email profile');
  }

  Future<AppUser?> _performAuthFlow({required String scopes}) async {
    // 1. Start local server
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
    
    // 2. Open browser
    final scopeEncoded = Uri.encodeComponent(scopes);
    final authUri = Uri.parse(
        '$_authUrl?client_id=$_clientId&redirect_uri=$_redirectUri&response_type=code&scope=$scopeEncoded&access_type=offline&prompt=consent');
    
    if (!await launchUrl(authUri)) {
      server.close();
      throw Exception('Could not launch browser for authentication.');
    }

    // 3. Wait for redirect
    try {
      final request = await server.first;
      final code = request.uri.queryParameters['code'];
      
      request.response.headers.contentType = ContentType.html;
      request.response.write('<html><body><h1>Authentication Successful!</h1><p>You can close this tab and return to Leads Studio.</p></body></html>');
      await request.response.close();
      await server.close();

      if (code == null) {
        throw Exception('Authorization code not found. Authentication was likely cancelled.');
      }

      // 4. Exchange code for tokens
      final response = await http.post(
        Uri.parse(_tokenUrl),
        body: {
          'code': code,
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'redirect_uri': _redirectUri,
          'grant_type': 'authorization_code',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception('Failed to get token: $data');
      }

      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];

      if (refreshToken != null) {
        await _storage.write(key: 'google_refresh_token', value: refreshToken);
      }

      // 5. Fetch user profile
      return await _fetchUserProfile(accessToken);
    } catch (e) {
      await server.close();
      throw Exception('Windows Auth flow failed: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'google_refresh_token');
    if (token == null) return null;
    try {
      return await _refreshAccessToken(token);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> requestScopes(List<String> scopes) async {
    try {
      await _performAuthFlow(scopes: ['email', 'profile', ...scopes].join(' '));
      return true;
    } catch (e) {
      print('DEBUG Auth Error: $e');
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await _storage.delete(key: 'google_refresh_token');
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse(_tokenUrl),
      body: {
        'client_id': _clientId,
        'client_secret': _clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      print('DEBUG Refresh Token Error: $data');
      throw Exception('Failed to refresh token');
    }
    return data['access_token'];
  }

  Future<AppUser> _fetchUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse(_userInfoUrl),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user profile');
    }

    return AppUser(
      id: data['id'],
      email: data['email'],
      displayName: data['name'],
      photoUrl: data['picture'],
    );
  }
}
