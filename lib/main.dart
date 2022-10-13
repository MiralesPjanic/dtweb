import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview/pages/splashscreen.dart';
import 'package:webview/provider/apiprovider.dart';
import 'package:webview/responsible_file/responsible_file.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview/utils/constants.dart';

int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBFRU8hDmhmZTUCq9S3vioxeaog58kJdcs",
            appId: "1:632145227488:ios:cda31127830d327317ea85",
            messagingSenderId: "632145227488",
            projectId: "myapp-e3d24"));
  } else {
    await Firebase.initializeApp();
  }
  MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt("initScreen");
  await preferences.setInt("initScreen", 1);

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(Constants().oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    debugPrint("Accepted permission: $accepted");
  });

  runApp(EasyLocalization(
    path: 'assets/translations', //
    supportedLocales: const [
      Locale('en'),
      Locale('hi'),
      Locale('ar'),
      Locale('fr', 'FR')
    ],
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              initialRoute: "/splash_screen",
              routes: {
                "/splash_screen": (context) => const SplashScreen(),
              },
            );
          });
        },
      ),
    ),
  ));
}
