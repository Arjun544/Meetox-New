import '../core/imports/core_imports.dart';
import '../core/imports/packages_imports.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  @override
  void onInit() {
    setupUserListener();
    super.onInit();
  }

  void setupUserListener() {
    supabase.channel('public:profiles').on(RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'INSERT', schema: 'public', table: 'profiles'),
        (payload, [ref]) {
      logSuccess('Change received: ${payload['new'].toString()}');
      final UserModel newUser = UserModel.fromJSON(payload['new']);
      currentUser(newUser);
    }).on(RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: 'UPDATE', schema: 'public', table: 'profiles'),
        (payload, [ref]) {
      logSuccess('Change received: ${payload.toString()}');
      final UserModel newUser = UserModel.fromJSON(payload['new']);
      currentUser(newUser);
    }).subscribe();
  }
}
