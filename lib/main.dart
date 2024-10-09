import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/services/apis/api_services.dart';
import 'package:app_tcareer/src/services/device_info_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_messaging_service.dart';
import 'package:app_tcareer/src/services/notifications/notification_handler.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:universal_io/io.dart';

// final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
//   return GlobalKey<NavigatorState>();
// });
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final container = ProviderContainer();
  container.read(deviceInfoProvider).configuration();
  try {
    await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyBa2suLLiuvDmkTisxPg1oxxYojKx40zhw",
              authDomain: "tcareer-4fa7d.firebaseapp.com",
              projectId: "tcareer-4fa7d",
              storageBucket: "tcareer-4fa7d.appspot.com",
              messagingSenderId: "353946571533",
              appId: "1:353946571533:web:f540d00c325bb1d272d644",
              measurementId: "G-JRVZ98QJCR")
          : DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('Firebase đã được khởi tạo trước đó.');
    } else {
      rethrow;
    }
  }
  container
      .read(notificationProvider(navigatorKey))
      .initializeNotificationServices();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(ProviderScope(
      // overrides: [navigatorKeyProvider.overrideWithValue(navigatorKey)],
      child: App(
    navigatorKey: navigatorKey,
  )));
}
