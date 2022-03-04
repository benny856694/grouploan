import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:group_loan/constants.dart';
import 'package:group_loan/src/auth/authgate.dart';
import 'package:group_loan/src/auth/signin.dart';
import 'package:group_loan/src/staffs/staffs.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:statusbarz/statusbarz.dart';

import 'groups/group_list.dart';
import 'settings/settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

final myNavigator = RM.injectNavigator(
    routes: {
      Groups.routeName: (context) => const Groups(),
      SignIn.routeName: (context) => const SignIn(),
      Staffs.routeName: (context) => const Staffs(),
    },
    initialLocation: SignIn.routeName,
    onNavigate: (routeData) {
      if (FirebaseAuth.instance.currentUser == null &&
          routeData.path != Constants.signinRouteName) {
        return routeData.redirectTo(SignIn.routeName);
      }

      if (FirebaseAuth.instance.currentUser != null &&
          routeData.path == Constants.signinRouteName) {
        return routeData.redirectTo(Groups.routeName);
      }

      Statusbarz.instance.refresh(delay: const Duration(milliseconds: 300));
      return null;
    });

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return StatusbarzCapturer(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            routerDelegate: myNavigator.routerDelegate,
            routeInformationParser: myNavigator.routeInformationParser,
          ),
        );
      },
    );
  }
}
