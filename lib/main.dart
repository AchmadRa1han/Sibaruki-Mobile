import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sibaruki_mobile/core/app_theme.dart';
import 'package:sibaruki_mobile/providers/auth_provider.dart';
import 'package:sibaruki_mobile/providers/sync_provider.dart';
import 'package:sibaruki_mobile/providers/rtlh_provider.dart';
import 'package:sibaruki_mobile/ui/screens/login_screen.dart';
import 'package:sibaruki_mobile/ui/screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => RtlhProvider()),
      ],
      child: const SibarukiApp(),
    ),
  );
}

class SibarukiApp extends StatelessWidget {
  const SibarukiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIBARUKI Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
