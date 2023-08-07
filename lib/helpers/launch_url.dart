import 'dart:io';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

void appLaunchUrl(String url) async {
  if (url.isURL == true && !url.contains('https') == true) {
    url = 'https://$url';
  }
  if (url.isPhoneNumber) {
    url = Platform.isAndroid
        ? 'whatsapp://send?phone=$url'
        : 'https://wa.me/$url';
    logError(url.toString());
  }
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } else {
    showToast('Could not launch url');
  }
}
