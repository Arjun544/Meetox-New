import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';

class UserServices {
  static Future<UserModel> getCurrentUser() async {
    try {
      final data = await supabase
          .from('profiles')
          .select('*')
          .eq('id', supabase.auth.currentUser!.id)
          .single()
          .withConverter((data) => UserModel.fromJson(data));
      return data;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }
}
