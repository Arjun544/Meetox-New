import 'package:meetox/core/imports/core_imports.dart';

bool isValidSocialUrl(String type, String url) {
  return type == 'whatsapp'
      ? true
      : url.isURL == true && url.contains(type.toLowerCase()) == true
          ? true
          : false;
}
