import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_share/database/singleton/uid.dart';
import 'package:todo_share/firebase_options.dart';
import 'package:todo_share/pages/create_user.dart';
import 'package:todo_share/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_share/pages/initial.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await UID().initialize();

  // Google Mobile Ads SDK を初期化
  MobileAds.instance.initialize();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = UID().uid;

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: uid != null ? HomePage() : InitialPage(isNewAccount: false),
      // home: DeadlineSetting(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en',''),
        const Locale('ja',''),
      ],
    );
  }
}
