import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localization/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleModel with ChangeNotifier {
  LocaleModel() {
    getLanguagePreferences();
    fetchTranslations();
  }

  Map<String, dynamic> _translations = {};
  Map<String, dynamic> _selectedTranslation = {};

  Locale locale;
  Locale get getlocale => locale;

  void changelocale(Locale l) {
    locale = l;
    _selectedTranslation = {};
    _selectedTranslation = _translations['${l.languageCode}'];
    notifyListeners();
  }

  Future<void> getLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('locale');
    locale = Locale(language ?? 'en');
  }

  Future<void> setLanguagePreferences(String l) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', l);
  }

  Future<void> fetchTranslations({String language = 'en'}) async {
    try {
      final response = await http.get(Uri.parse(translationsApi));
      if (response != null) {
        if (response.statusCode == 200) {
          final Map decoded = json.decode(response.body);
          _translations = decoded;
          _selectedTranslation = decoded[language];
        }
      }
    } catch (_) {
      print(_.toString());
    }
  }

  set translations(Map<String, dynamic> map) {
    _selectedTranslation = map;
    notifyListeners();
  }

  Map<String, dynamic> get translations => _selectedTranslation;
}
