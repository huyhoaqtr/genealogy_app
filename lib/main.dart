import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'constants/app_pages.dart';
import 'constants/app_routes.dart';
import 'multialanguage/app_locale.dart';
import 'multialanguage/app_translations.dart';
import 'services/ads/ad_manager.dart';
import 'services/firebase/fcm_service.dart';
import 'services/socket/SocketClientManager.dart';
import 'services/storage/hive_manager.dart';
import 'utils/theme/theme.dart';
import 'utils/widgets/loading/loading.common.dart';
import 'utils/widgets/loading/loading.controller.dart';
import 'views/splash/splash.binding.dart';
import 'views/splash/splash.screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  AdManager.loadInterstitialAd();
  await Firebase.initializeApp();
  if (!kIsWeb && (Platform.isAndroid)) {
    FCMService.initializeFCM();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting('vi', null);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(microseconds: 50))
      .then((value) => FlutterNativeSplash.remove());

  // Hive app
  await HiveManager.shared.initHive();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));

  Get.put(LoadingController());
  SocketClientManager().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            defaultTransition: Transition.cupertino,
            getPages: AppPages.pages,
            locale: AppLocale()
                .listLanguages[HiveManager.shared.getCurrentAppLanguage()],
            fallbackLocale: const Locale('vi', 'VN'),
            translations: AppTranslations(),
            home: const SplashScreen(),
            theme: buildThemeData(),
            initialBinding: SplashBinding(),
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  const LoadingOverlay(),
                ],
              );
            },
          );
        });
  }
}
