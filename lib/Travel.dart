
import 'dart:convert';

class Travel {

  final String cost, time, date, dist, wait, start;

  Travel({required this.cost,required this.time,required this.date,required this.wait,required this.dist, required this.start});

  factory Travel.fromJson(Map<String, dynamic> jsonData) {
    return Travel(
      cost: jsonData['cost'],
      time: jsonData['time'],
      date: jsonData['date'],
      wait: jsonData['wait'],
      start: jsonData['start'],
      dist: jsonData['dist'],
    );
  }
  static Map<String, dynamic> toJson(Travel travel) => {
    "cost": travel.cost,
    "time": travel.time,
    "date": travel.date,
    "wait": travel.wait,
    "dist": travel.dist,
    "start": travel.start
  };

  @override
  String toString() {
    return '"travel" : { "cost" : $cost, "time": $time, "date": $date, "dist": $dist, "wait": $wait }';
  }
  /*static String encode(List<Travel> travels) => json.encode(
    travels.map((e) => Travel.toMap(e)).toList()
  );
  static List<Travel> decode(String travels) => (
      (json.decode(travels) as List<dynamic>).map((e) => Travel.fromJson(e)).toList()
  );*/
}