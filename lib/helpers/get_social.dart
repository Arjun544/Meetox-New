import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

IconData getSocial(String social) {
  switch (social.toLowerCase()) {
    case 'instagram':
      return FlutterRemix.instagram_fill;
    case 'facebook':
      return FlutterRemix.facebook_fill;
    case 'whatsapp':
      return FlutterRemix.whatsapp_fill;
    default:
      return IconsaxBold.link_21;
  }
}
