import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseDatabaseService {
  final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://tcareer-4fa7d-default-rtdb.asia-southeast1.firebasedatabase.app");

  Future<Map<dynamic, dynamic>?> getData(String path) async {
    try {
      DatabaseReference ref = database.ref(path);
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        return snapshot.value as Map<dynamic, dynamic>;
      } else {
        print("Not data");
      }
    } catch (e) {
      print("$e");
      rethrow;
    }
    return null;
  }

  Stream<DatabaseEvent> listenToData(String path) {
    DatabaseReference ref = database.ref(path);
    return ref.onValue;
  }
}

final firebaseDatabaseServiceProvider =
    Provider<FirebaseDatabaseService>((ref) => FirebaseDatabaseService());
