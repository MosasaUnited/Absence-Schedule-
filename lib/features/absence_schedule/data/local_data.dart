import 'dart:convert';

import 'package:absence_schedule/common/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/models/management.dart';

class LocalData {
  static late final SharedPreferences _pref;

  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static void setSections(List<Section> sections) {
    String json = jsonEncode(sections);
    _pref.setString(Keys.management, json);
  }

  static List<Section> getSections() {
    String? json = _pref.getString(Keys.management);
    if (json == null) return [];
    List<dynamic> data = jsonDecode(json);
    List<Section> sections =
        data.map((section) => Section.fromJson(section)).toList();
    return sections;
  }
}
