import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/const.dart';
import 'package:localization/locale_model.dart';
import 'package:localization/settings.dart';
import 'package:localization/user_model.dart';
import 'package:localization/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
          print('rebuilt');
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Future<void> getUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.get(Uri.parse(randomApi));
      if (res.statusCode == 200) {
        final decodedResponse = json.decode(res.body);
        user = UserModel.fromJson(decodedResponse['results'][0]);
      }
      setState(() {
        isLoading = false;
      });
    } catch (_) {
      print(_.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 40, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              localize(
                  _localeModel.translations['userIntro'], [user.name.first]),
              style: TextStyle(fontSize: 40),
            ),
          ),
          // Spacer(),
          Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  user.picture.large,
                ),
              )),
        ],
      ),
    );
  }

  bool isLoading = false;
  UserModel user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    iconController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _settings = Provider.of<Settings>(context, listen: false);
    isDarkNotifier = ValueNotifier(_settings.theme == AppTheme.dark);
  }

  Widget _description() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Text(
          localize(_localeModel.translations['aboutUser'],
              [user.location.city, user.location.state, user.location.country]),
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
      ),
    );
  }

  Widget stackedLogo(String title) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        Padding(
            padding: EdgeInsets.only(left: 5, top: 4),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.5)),
            )),
      ],
    );
  }

  AnimationController iconController;
  LocaleModel _localeModel;
  Settings _settings;
  ValueNotifier<bool> isDarkNotifier;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
          create: (_) => LocaleModel(),
          child: Consumer<LocaleModel>(builder: (context, provider, child) {
            _localeModel = provider;
            return Scaffold(
              body: isLoading ||
                      _localeModel.translations.isEmpty ||
                      user == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ValueListenableBuilder<bool>(
                            valueListenable: isDarkNotifier,
                            builder: (_, theme, child) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    stackedLogo('Profile'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(isDarkNotifier.value
                                            ? Icons.brightness_2_outlined
                                            : Icons.wb_sunny_rounded),
                                        CupertinoSwitch(
                                          value: theme,
                                          onChanged: (isDark) {
                                            isDarkNotifier.value = isDark;
                                            if (isDark) {
                                              iconController.forward();
                                              Provider.of<Settings>(context,
                                                      listen: false)
                                                  .theme = AppTheme.dark;
                                            } else {
                                              iconController.reverse();
                                              Provider.of<Settings>(context,
                                                      listen: false)
                                                  .theme = AppTheme.light;
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          _title(),
                          _description(),
                          Connections()
                        ],
                      ),
                    ),
            );
          })),
    );
  }
}

class Connections extends StatefulWidget {
  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Future<List<UserModel>> getConnections() async {
    try {
      final res = await http.get(Uri.parse(RANDOM_CONNECTIONS));
      if (res.statusCode == 200) {
        Iterable data = json.decode(res.body)['results'];
        final list = data.map((e) => UserModel.fromJson(e)).toList();
        return list;
      }
    } catch (_) {
      return Future.error('Failed to Load');
    }
  }

  Widget _userCard(UserModel user, int index) {
    return Container(
      margin: EdgeInsets.only(right: 16, left: index == 0 ? 16 : 0),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                  user.picture.large,
                ),
              )),
          Text(
            user.name.first,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'People you may know',
            style: TextStyle(fontSize: 25),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        FutureBuilder<List<UserModel>>(
            future: getConnections(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return Container(
                    height: 200,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, x) => _userCard(snapshot.data[x], x),
                    ));
            }),
      ],
    );
  }
}
