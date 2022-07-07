

import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:sprintf/sprintf.dart';
import 'package:taxi/Prices.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi/Travel.dart';
import 'package:taxi/end_dialog.dart';
import 'package:taxi/utils.dart';
import 'package:taxi/wait_dialog.dart';
import 'package:wakelock/wakelock.dart';
import 'package:geolocator_android/src/types/foreground_settings.dart';
import 'dart:convert';

import 'dialog.dart';

class HomePage extends StatefulWidget {

  @override
  HomeState createState() {

    return HomeState();
  }
}

class HomeState extends State<HomePage> {

  late var locationCurrent = null;
  bool _serviceStarted = false;
  late double distance = 0, cost = 0, wait = 0;
  int _time = 0, _wait_time = 0;
  late Timer timer;
  int _km = 0, _start = 0, _wait = 0;
  late Prices? _prices = null;
  bool _paused = false;
  Stream<Position>? stream = null;
  var prefs;
  late double _free_km;
  late int _free_wait;
  late StreamSubscription<Position>? subscription;
  late String _selectedValue = 'Эконом';
  List<String> list = ['Эконом','Комфорт','Бизнес'];
  List<String> all = [];

  @override
  void dispose() {
    // TODO: implement dispose
    _prices = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('$_wait_time');
    Wakelock.enable();
    if(stream==null) initPrefs();
    if(_prices==null) {
      int ind;
      FirebaseRemoteConfig.instance.fetchAndActivate().then((value) => FirebaseRemoteConfig.instance.ensureInitialized()).then((value) => {
        add(),
        ind = list.indexOf(_selectedValue),
        setState(()=>{
          _free_km = double.parse(FirebaseRemoteConfig.instance.getString("free_km")),
          _free_wait = int.parse(FirebaseRemoteConfig.instance.getString("free_wait"))*60,
          _start = int.parse(all[ind*3]),
          _km = int.parse(all[ind*3+1]),
          _wait = int.parse(all[ind*3+2]),
          _prices = Prices(km: _km.toString(), start: _start.toString(), wait: _wait.toString()),
          cost = _start.toDouble()
        })
      });
    }
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, '/settings');
            initPrefs();
          },
          child: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset('assets/settings.png', height: 30,width: 30,),
          ),
        ),
        title: const Text("Главная"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Text(cost.toStringAsFixed(2),
              style: const TextStyle(fontSize: 75,color: Colors.amber)),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20,bottom: 30),
              child: const Text("сумма",
              style: TextStyle(fontSize: 20,color: Colors.amber),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset('assets/route.png', width: 30, height: 30,),
                  ),
                  Text(distance.toStringAsFixed(3)),
                  Container(
                    padding: const EdgeInsets.only(left: 60,right: 20),
                    child: Image.asset('assets/time2.png', width: 30, height: 30,),
                  ),
                  Text(getTime())
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 30),
              child: stream==null ?
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/list');
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  primary: Colors.amber,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: const Text('Поездки', style: TextStyle(fontSize: 20),),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: ElevatedButton(
                        onPressed: () {
                          setState((){
                            if(!_paused) {
                              timer.cancel();
                            } else {
                              startTimer();
                            }
                            _paused = !_paused;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(170, 50),
                          primary: _paused ? Colors.green : Colors.amber,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: _paused ? const Text('Продолжить', style: TextStyle(fontSize: 20),)
                            : const Text('Пауза',style: TextStyle(fontSize: 20),)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: ElevatedButton(
                        onPressed: _paused ? null : () async {
                          showDialog(context: context, builder: (context) {
                            return CustomDialog(
                              content: "Включить ожидание?",
                              onTap: () async {
                                Navigator.pop(context);
                                _wait_time += await showGeneralDialog(context: context, pageBuilder: (a,b,c){
                                  return WaitDialog(time: _wait_time, wait: _wait,free: _free_wait,);
                                }) ?? 0;
                                setState(() async {
                                  cost = _start.toDouble()+((distance>_free_km ? distance-_free_km : 0)*_km)+(_wait*(_wait_time>_free_wait ? _wait_time-_free_wait : 0)/60);
                                });
                              },
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Text('Ожидание', style: TextStyle(fontSize: 20),)
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () async {
                  if(stream==null) {
                    await getLocation();
                    if(stream!=null) startTimer();
                  } else {
                    showDialog(context: context, builder: (context){
                    return CustomDialog(onTap: () {
                      getLocation();
                      timer.cancel();
                      Navigator.pop(context);
                      DateTime date = DateTime.now();
                      DateFormat format = DateFormat('dd.MM.yyyy');
                      var travel = Travel(cost: cost.toStringAsFixed(2), time: _time.toString(),
                          date: format.format(date), wait: _wait_time.toString(), dist: distance.toStringAsFixed(3),start: _start.toString());
                      Utils.save(prefs, travel);
                      setState((){
                        _time = 0;
                        distance = 0.0;
                        _wait_time = 0;
                        cost = _start.toDouble();
                      });
                      showGeneralDialog(context: context, pageBuilder: (a,b,c) {
                        return EndDialog(travel: travel,onTap: () {
                          Navigator.pop(context);
                        });
                      });
                     }, content: "Завершить поездку?",);
                    });

                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 50),
                  primary: stream==null ? Colors.green : Colors.red,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: stream==null ? const Text('Старт',style: TextStyle(fontSize: 20),)
                    : const Text('Завершить',style: TextStyle(fontSize: 20),),
              ),
            )
          ],
        ),
      ),
    );
  }
  String getTime() {
    int _hours = _time~/3600, _mins = (_time%3600)~/60, _secs = _time%60;
    return sprintf('%02d:%02d:%02d',[_hours,_mins,_secs]);
  }

  int distCalc(Position first, Position second) {
    double lat1 = double.parse(first.latitude.toStringAsFixed(4))*math.pi/180.0,
      lat2 = double.parse(second.latitude.toStringAsFixed(4))*math.pi/180.0,
      long1 = double.parse(first.longitude.toStringAsFixed(4))*math.pi/180.0,
      long2 = double.parse(second.longitude.toStringAsFixed(4))*math.pi/180.0;
    
    double cos1 = math.cos(lat1),
          cos2 = math.cos(lat2),
          sin1 = math.sin(lat1),
          sin2 = math.sin(lat2),
          delta = long2-long1,
          cosDelta = math.cos(delta),
          sinDelta = math.sin(delta);
    
    double y = math.sqrt(math.pow(cos2*sinDelta, 2)+math.pow(cos1*sin2-sin1*cos2*cosDelta, 2)),
          x = sin1*sin2+cos1*cos2*cosDelta;
    double at = math.atan2(y, x);
    return (at*6372795).ceil();
  }


  Future<void> getLocation() async {
    if(stream!=null) {
      subscription!.cancel();
      subscription = null;
      stream = null;
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied) {
     permission =  await Geolocator.requestPermission();
    }
    if(!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return;
    }
    if(!await Geolocator.isLocationServiceEnabled()) {
      //await Geolocator.openLocationSettings();
      await Geolocator.openAppSettings();
      return;
    }
    LocationSettings settings;
    if(defaultTargetPlatform==TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        forceLocationManager: true,
        intervalDuration: const Duration(milliseconds: 100),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationTitle: 'Такси Гьели',
            notificationText: 'Поездка началась',
            enableWakeLock: true,
            notificationIcon: AndroidResource(name: 'icon',defType: 'mipmap'))
      );
    } else if(defaultTargetPlatform==TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.best,
        showBackgroundLocationIndicator: true,
      );
    } else {
        settings = const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 0);
    }
    setState((){
      stream =  Geolocator.getPositionStream(locationSettings:
      settings);
    });
    subscription = stream!.listen((event) {
      if(stream==null) {
        return;
      }
      if(locationCurrent==null) {
          locationCurrent = event;
          return;
        }
        if((locationCurrent.latitude-event.latitude).abs()<0.00001
            && (locationCurrent.longitude-event.longitude).abs()<0.00001) {
          locationCurrent = event;
          return;
        }
        if(_paused) {
          locationCurrent = event;
          return;
        }
        setState((){
          distance+=double.parse((Geolocator.distanceBetween(locationCurrent.latitude, locationCurrent.longitude, event.latitude, event.longitude)/1000).toStringAsFixed(3));
          cost = _start.toDouble()+((distance>_free_km ? distance-_free_km : 0)*_km)+(_wait*(_wait_time>_free_wait ? _wait_time-_free_wait : 0)/60);
        });

        locationCurrent = event;
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState((){
        _time++;
      });
    });
  }

  void initPrefs() async {
    if(prefs==null) prefs = await SharedPreferences.getInstance();
    setState((){
      _selectedValue = prefs.getString('tarif') ?? 'Эконом';
      int ind = list.indexOf(_selectedValue);
      _start = int.parse(all[ind*3]);
      _km = int.parse(all[ind*3+1]);
      _wait = int.parse(all[ind*3+2]);
      cost = _start.toDouble();
      _prices = Prices(km: _km.toString(), start: _start.toString(), wait: _wait.toString());
    });
  }
  void add() {
    all.add(FirebaseRemoteConfig.instance.getString("ekonom_start_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("ekonom_km_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("ekonom_wait_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("komfort_start_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("komfort_km_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("komfort_wait_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("bisnes_start_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("bisnes_km_cost"));
    all.add(FirebaseRemoteConfig.instance.getString("bisnes_wait_cost"));
  }
}