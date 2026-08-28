import 'package:http/http.dart' as http;

class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final String _token;

  AuthClient(this._token, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _inner.send(request);
  }
}
