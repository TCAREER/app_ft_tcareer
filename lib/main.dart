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

  // Chỉ khởi tạo Firebase một lần
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

  runApp(ProviderScope(child: App()));
}
