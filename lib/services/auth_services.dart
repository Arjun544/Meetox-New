import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:meetox/screens/auth_screens/auth_screen.dart';
import '../core/imports/packages_imports.dart';

import '../core/imports/core_imports.dart';

class AuthServices {
  static String generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  static Future<AuthResponse> signInWithGoogle(RxBool isLoading) async {
    try {
      isLoading(true);

      final rawNonce = generateRandomString();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final clientId = Platform.isIOS
          ? '81060931160-mtf9ddlk7hofqg3ua54jomgb3nu3c2r9.apps.googleusercontent.com'
          : '81060931160-3end1kftav59msgolumc56j0arj60hos.apps.googleusercontent.com';

      final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

      const discoveryUrl =
          'https://accounts.google.com/.well-known/openid-configuration';

      const appAuth = FlutterAppAuth();

      final result = await appAuth.authorize(
        AuthorizationRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          nonce: hashedNonce,
          scopes: [
            'openid',
            'email',
            'profile',
          ],
        ),
      );

      if (result == null) {
        throw 'No result';
      }

      // Request the access and id token to google
      final tokenResult = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          authorizationCode: result.authorizationCode,
          discoveryUrl: discoveryUrl,
          codeVerifier: result.codeVerifier,
          nonce: result.nonce,
          scopes: [
            'openid',
            'email',
            'profile',
          ],
        ),
      );

      final idToken = tokenResult?.idToken;

      if (idToken == null) {
        throw 'No idToken';
      }

      return supabase.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        nonce: rawNonce,
      );
    } catch (e) {
      isLoading(false);
      logError(e.toString());
      rethrow;
    }
  }

  static Future logout() async {
    try {
      await supabase.auth.signOut();
      Get.offAll(() => const AuthScreen());
    } catch (e) {
      logError(e.toString());
    }
  }
}
