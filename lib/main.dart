import 'package:fl_query/fl_query.dart';
import 'package:fl_query_connectivity_plus_adapter/fl_query_connectivity_plus_adapter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/imports/core_imports.dart';
import 'core/imports/packages_imports.dart';
import 'core/time_ago_messages.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'models/user_model.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await supabaseInit();
  timeago.setLocaleMessages('en', TimeAgoMessages());
  await QueryClient.initialize(
    cachePrefix: 'meetox',
    connectivity: FlQueryConnectivityPlusAdapter(),
  );

  // if (getStorage.read('first_run') ?? true) {
  //   await SecureStorageServices.clearAll();
  //   await getStorage.write('first_run', false);
  // }

  // Map tiles caching
  await FlutterMapTileCaching.initialise(
    settings: FMTCSettings(
      databaseMaxSize: FMTCTileProviderSettings().maxStoreLength,
    ),
    debugMode: true,
  );

  final mapLight = FMTC.instance('Map light');
  final mapDark = FMTC.instance('Map dark');
  final mapSky = FMTC.instance('Map sky');
  final mapMeetox = FMTC.instance('Map meetox');

  await mapLight.manage.createAsync();
  await mapDark.manage.createAsync();
  await mapSky.manage.createAsync();
  await mapMeetox.manage.createAsync();
  runApp(const MyApp());
}

final Rx<UserModel> currentUser = UserModel(
  id: '',
  name: '',
  photo: '',
  isPremium: false,
  location: LocationModel(),
  socials: {},
  createdAt: DateTime.now(),
).obs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final currentTheme = getStorage.read('theme') ?? 'system';

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: QueryClientProvider(
          maxRetries: 1,
          refreshOnMount: false,
          child: GetMaterialApp(
            title: 'Meetox',
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            themeMode: currentTheme == 'light'
                ? ThemeMode.light
                : currentTheme == 'dark'
                    ? ThemeMode.dark
                    : ThemeMode.system,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
