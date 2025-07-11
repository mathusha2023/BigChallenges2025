import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

class Keycloak {
  final String baseUrl = dotenv.env['KEYCLOAK_URL'] ?? '';
  final String realm = dotenv.env['REALM'] ?? '';
  final String clientId = dotenv.env['CLIENT_ID'] ?? '';
  final String clientSecret = dotenv.env['CLIENT_SECRET'] ?? '';
  final storage = const FlutterSecureStorage();
  static final instance = Keycloak();

  Future<UserInfo?> login() async {
    try {
      var issuer = await Issuer.discover(Uri.parse("$baseUrl/realms/$realm"));

      var client = Client(issuer, clientId, clientSecret: clientSecret);

      var authenticator = Authenticator(
        client,
        scopes: ['openid'],
        redirectMessage: "",
        port: 4000,
        redirectUri: Uri.parse("http://localhost:4000"),
        urlLancher: (url) async {
          Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.inAppWebView);
          }
        },
      );
      var credentials = await authenticator.authorize();

      await closeInAppWebView();

      var tokenInfo = await credentials.getTokenResponse();

      var userInfo = await credentials.getUserInfo();

      await storage.write(key: "access_token", value: tokenInfo.accessToken);
      await storage.write(key: "refresh_token", value: tokenInfo.refreshToken);
      await storage.write(
        key: "expires_in",
        value: tokenInfo.expiresAt?.millisecondsSinceEpoch.toString(),
      );

      await storage.write(
        key: "logout_uri",
        value: credentials.generateLogoutUrl().toString(),
      );

      await storage.write(key: "user_id", value: userInfo.subject);
      await storage.write(key: "user_name", value: userInfo.name);
      return userInfo;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await storage.read(key: "refresh_token");
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/realms/$realm/protocol/openid-connect/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "refresh_token",
        "client_id": clientId,
        "refresh_token": refreshToken,
        "client_secret": clientSecret,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "access_token", value: data["access_token"]);
      await storage.write(key: "refresh_token", value: data["refresh_token"]);
      await storage.write(
        key: "expires_in",
        value: data["expires_in"].toString(),
      );
      return true;
    }
    return false;
  }

  Future<bool> isTokenExpired() async {
    final expiresInStr = await storage.read(key: "expires_in");
    if (expiresInStr == null) return true;
    final expiresIn = int.tryParse(expiresInStr) ?? 0;
    return DateTime.now().millisecondsSinceEpoch >= expiresIn;
  }

  Future<bool> logout() async {
    final url = await storage.read(key: "logout_uri");
    Uri uri = Uri.parse(
      url ?? "$baseUrl/realms/$realm/protocol/openid-connect/logout",
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
        await closeInAppWebView();
        await storage.deleteAll();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
