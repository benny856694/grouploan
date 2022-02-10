import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:group_loan/src/auth/authgate.dart';
import 'package:group_loan/src/staffs/staffs.dart';

import 'groups/group_list.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            const providers = [EmailProviderConfiguration()];

            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SampleItemListView.routeName:
                    return const SampleItemListView();
                  case Staffs.routeName:
                    return const Staffs();
                  case Groups.routeName:
                    return const Groups();
                  default:
                    return FirebaseAuth.instance.currentUser == null
                        ? SignInScreen(
                            providerConfigs: providers,
                            showAuthActionSwitch: false,
                            headerBuilder: (context, constraints, _) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'assets/images/logo.jpeg',
                                  ),
                                ),
                              );
                            },
                            sideBuilder: (context, constraints) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'assets/images/logo.jpeg',
                                  ),
                                ),
                              );
                            },
                            subtitleBuilder: (context, action) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                    'Welcome to Group Loan! Please sign in to continue.'),
                              );
                            },
                            footerBuilder: (context, action) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'By signing in, you agree to our Terms of Service and Privacy Policy.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                            actions: [
                              AuthStateChangeAction<SignedIn>(
                                (context, _) {
                                  Navigator.of(context).pushReplacementNamed(
                                    Groups.routeName,
                                  );
                                },
                              ),
                            ],
                          )
                        : const Groups();
                }
              },
            );
          },
        );
      },
    );
  }
}
