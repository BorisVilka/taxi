import 'dart:convert';
import 'Travel.dart';

class Date {

  final String date;
  List<Travel> list;
  Date({required this.date,required this.list});

  factory Date.fromJson(Map<String, dynamic> jsonData) {
    return Date(date: jsonData['date'],
        list: List<Travel>.from(jsonData['list'].map((e)=>Travel.fromJson(e)).toList())
    );
  }
  static Map<String,dynamic> toJson(Date date) => {
    'date': date.date,
    'list': date.list.map((e) => Travel.toJson(e)).toList()
  };
  //static encode(List<Date> dates) => json.encode(dates.map((e) => Date.toMap(e)).toList());
  //static List<Date> decode(String dates) => (json.decode(dates) as List<dynamic>).map((e) => Date.fromJson(e)).toList();

  @override
  String toString() {
    return '"date" : { ${list.toString()}, "date": $date';
  }
}