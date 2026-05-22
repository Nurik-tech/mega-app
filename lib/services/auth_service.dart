import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
    await storage.write(key: 'token', value: 'dummy_token');
    return true; // always succeed
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay
    await storage.write(key: 'token', value: 'dummy_token');
    return true; // always succeed
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
