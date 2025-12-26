import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodo/core/routing/app_router.dart';
import 'package:kodo/firebase_options.dart';
import 'package:kodo/src/services/storage_service.dart';
import 'package:kodo/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await KodoStorageService.instance.init();
  runApp(ProviderScope(child: const KodoApp()));
}

class KodoApp extends StatelessWidget {
  const KodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: KodoTheme.lightTheme,
      darkTheme: KodoTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
