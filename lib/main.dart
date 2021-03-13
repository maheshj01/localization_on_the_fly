import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/home.dart';
import 'package:localization/locale_model.dart';
import 'package:localization/settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleModel>(create: (_) => LocaleModel()),
        ChangeNotifierProvider<Settings>(
            create: (_) => Settings(AppTheme.light)),
      ],
      child: Consumer2<Settings, LocaleModel>(
        builder: (BuildContext context, Settings provider, LocaleModel locale,
            Widget child) {
          return MaterialApp(
            title: 'Localization',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            theme: ThemeData.light(),
            themeMode: provider.theme == AppTheme.light
                ? ThemeMode.light
                : ThemeMode.dark,
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}
