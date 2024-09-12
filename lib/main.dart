import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/services/apis/api_services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  if (kIsWeb) {
    Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBa2suLLiuvDmkTisxPg1oxxYojKx40zhw",
            authDomain: "tcareer-4fa7d.firebaseapp.com",
            projectId: "tcareer-4fa7d",
            storageBucket: "tcareer-4fa7d.appspot.com",
            messagingSenderId: "353946571533",
            appId: "1:353946571533:web:f540d00c325bb1d272d644",
            measurementId: "G-JRVZ98QJCR"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'), // For web
    androidProvider: AndroidProvider.debug, // For Android
    appleProvider: AppleProvider.debug, // For iOS
  );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  runApp(ProviderScope(
      child: App(
    navigatorKey: navigatorKey,
  )));
}
