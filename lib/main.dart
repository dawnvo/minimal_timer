import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:minimal_timer/configs/colors.dart';
import 'package:minimal_timer/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Timer',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        splashFactory: NoSplash.splashFactory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CustomColors.primary,
          primary: CustomColors.primary,
          outline: CustomColors.outline,
          error: CustomColors.error,
          background: CustomColors.surface,
          surface: CustomColors.surface,
          onSurface: CustomColors.onSurface,
          onSurfaceVariant: CustomColors.onSurfaceVariant,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
