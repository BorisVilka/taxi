
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:taxi/Date.dart';
import 'package:taxi/Travel.dart';

class Utils {

  static String getTime(int _time) {
    int _hours = _time~/3600, _mins = (_time%3600)~/60, _secs = _time%60;
    return sprintf('%02d:%02d:%02d',[_hours,_mins,_secs]);
  }

  static void save(SharedPreferences prefs, Travel travel) {
    //prefs.setString('list', jsonEncode(Date.toJson(Date(date: travel.date,list: [travel]))));
    String? s = prefs.getString('list');
    List<Date> dates = s==null ? [] : List<Date>.from(jsonDecode(s).map((e)=>Date.fromJson(e)).toList());
    bool b = false;
    for(int i = 0;i<dates.length;i++) {
      if(dates[i].date.compareTo(travel.date)==0) {
        b = true;
        dates[i].list.add(travel);
        break;
      }
    }
    if(!b) {
      dates.add(Date(date: travel.date, list: [travel]));
    }
    prefs.setString('list', jsonEncode(dates.map((e) => Date.toJson(e)).toList()));
  }
}