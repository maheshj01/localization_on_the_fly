import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localization/const.dart';

class LocaleModel with ChangeNotifier {
  LocaleModel() {
    fetchTranslations();
  }

  Map<String, dynamic> _translations = {};

  Locale locale;
  Locale get getlocale =>
      locale ??
      Locale(Platform.localeName.contains('en')
          ? 'en_US'
          : Platform.localeName.contains('de')
              ? 'de'
              : Platform.localeName);

  set changelocale(Locale l) {
    locale = l;
    notifyListeners();
  }

  Future<void> fetchTranslations() async {
    try {
      final response = await http.get(Uri.parse(translationsApi));
      if (response != null) {
        if (response.statusCode == 200) {
          final Map decoded = json.decode(response.body);
          translations = decoded;
        }
      }
    } catch (_) {
      print(_.toString());
    }
  }

  set translations(Map<String, dynamic> map) {
    _translations = map;
    notifyListeners();
  }

  Map<String, dynamic> get translations => _translations;
}
