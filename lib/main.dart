import 'package:fbTrade/global.dart';
import 'package:fbTrade/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'I10n/AppLanguage.dart';
import 'I10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  await getAppInfo();
  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (_) => appLanguage,
        child: Consumer<AppLanguage>(
          builder: (context, model, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              supportedLocales: [
                Locale("en", "US"),
                Locale("ar", ""),
              ],
              locale: model.appLocal,
              title: 'fluffy & tasty',
              theme: ThemeData(
                primaryColor: Colors.blue,
                textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'tajawal',
                    ),
              ),
              home: SplashScreen(),
            );
          },
        ));
  
  }
}
