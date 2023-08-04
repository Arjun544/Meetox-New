import 'dart:convert';

import '../core/imports/core_imports.dart';
import '../core/imports/packages_imports.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  @override
  void onReady() {
    setupUserListener();
    super.onReady();
  }

  void setupUserListener() {
    supabase
        .channel('public:profiles:id=eq.${supabase.auth.currentUser!.id}')
        .on(
            RealtimeListenTypes.postgresChanges,
            ChannelFilter(
              event: 'UPDATE',
              schema: 'public',
              table: 'profiles',
              filter: 'id=eq.${supabase.auth.currentUser!.id}',
            ), (payload, [ref]) {
      logSuccess('Change received: ${jsonEncode(payload['new'])}');
      final UserModel newUser = UserModel.fromJSON(payload['new']);
      currentUser(newUser);
    }).subscribe();
    //  supabase.channel('public:profiles').on(RealtimeListenTypes.postgresChanges,
    //       ChannelFilter(event: 'INSERT', schema: 'public', table: 'profiles'),
    //       (payload, [ref]) {
    //     logSuccess('Change received: ${payload['new'].toString()}');
    //     final UserModel newUser = UserModel.fromJSON(payload['new']);
    //     currentUser(newUser);
    //   }).on(RealtimeListenTypes.postgresChanges,
    //       ChannelFilter(event: 'UPDATE', schema: 'public', table: 'profiles'),
    //       (payload, [ref]) {
    //     logSuccess('Change received: ${payload.toString()}');
    //     final UserModel newUser = UserModel.fromJSON(payload['new']);
    //     currentUser(newUser);
    //   }).subscribe();
  }
}
