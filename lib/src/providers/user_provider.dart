import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/storage_service.dart';
import 'package:kodo/src/services/user_service.dart';
import 'package:riverpod/riverpod.dart';

final userProvider = StreamProvider<KodoUser?>((ref) {
  final uid = AuthService.currentUser?.uid;
  if (uid == null) return Stream.empty();

  return KodoUserService().getUserStream(uid).asyncMap((snapshot) async {
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    final user = KodoUser.fromDoc(snapshot);
    await KodoStorageService.instance.cacheUser(user);
    return user;
  });
});
