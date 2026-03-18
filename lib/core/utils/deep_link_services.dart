import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes/route_names.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> initialize(BuildContext context) async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri, context);
    }

    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri, context);
    });
  }

  static void _handleUri(Uri uri, BuildContext context) {
    // ── Confirm Email ──
    if (uri.path.contains('confirm-email')) {
      final userId = uri.queryParameters['userid'];
      final code = uri.queryParameters['code'];
      if (userId != null && code != null) {
        context.push(
          RouteNames.confirmEmail,
          extra: {'userId': userId, 'code': code},
        );
      }
    }

    // ── Reset Password ──
    // reset-p يشمل reset-pss و reset-password
    if (uri.path.contains('reset-p')) {
      final email = uri.queryParameters['email'];
      final code = uri.queryParameters['code'];
      if (email != null && code != null) {
        context.push(
          RouteNames.enterCode,
          extra: {'email': email, 'code': code},
        );
      }
    }
  }
}