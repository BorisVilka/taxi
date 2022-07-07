import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/Prices.dart';

class TarifPage extends StatefulWidget {

  const TarifPage({Key? key}) : super(key: key);

  @override
  _TarifState createState() {

    return _TarifState();
  }
}

class _TarifState extends State<TarifPage> {

  var _selectedValue = "Эконом";
  late String _start = "", _km = "", _wait = "", _free_km = "", _free_wait = "";
  var prefs;
  var prices;
  List<String> list = ['Эконом','Комфорт','Бизнес'];
  List<String> all = [];

  @override
  void initState()  {

  }

  @override
  void dispose() {
    // TODO: implement dispose
    prices = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  // TODO: implement build
    if(prefs==null) initPrefs();
    if(prices==null) {
      int ind;
      FirebaseRemoteConfig.instance
          .setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 90), minimumFetchInterval: const Duration(seconds: 0)))
          .then((value) => FirebaseRemoteConfig.instance.fetchAndActivate()).then((value) => {
        setState(()=>{
          add(),
          ind = list.indexOf(_selectedValue),
          _start = (all[ind*3]),
          _km = (all[ind*3+1]),
          _wait = (all[ind*3+2]),
          _free_km = FirebaseRemoteConfig.instance.getString("free_km"),
          _free_wait = FirebaseRemoteConfig.instance.getString("free_wait"),
          prices = Prices(km: _km.toString(), start: _start.toString(), wait: _wait.toString()),
        })
      });
    }
  int ind;
  return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
    body: Center(
        child:
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: const Text('Тариф',
            style: TextStyle(fontSize: 30),),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: DropdownButton(items: const <DropdownMenuItem<String>>[
              DropdownMenuItem(value: "Эконом", child: Text("Эконом")),
              DropdownMenuItem(value: "Комфорт", child: Text("Комфорт")),
              DropdownMenuItem(value: "Бизнес", child: Text("Бизнес")),
            ],
              style: const TextStyle(fontSize: 24),
              onChanged: (obj)=>{
                setState(()=>{
                  _selectedValue = obj as String,
                  ind = list.indexOf(_selectedValue),
                  _start = (all[ind*3]),
                  _km = (all[ind*3+1]),
                  _wait = (all[ind*3+2]),
                  prices = Prices(km: _km.toString(), start: _start.toString(), wait: _wait.toString()),
                })
              },
              value: _selectedValue,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.only(right: 10),
                child: Image.asset('assets/som.png', width: 30, height: 30,),),
                const Padding(padding: EdgeInsets.only(right: 87),
                child: Text('Посадка',style: TextStyle(fontSize: 24),)),
                Padding(padding: const EdgeInsets.only(right: 30),
                    child: Text(_start,style: const TextStyle(fontSize: 24),)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.only(right: 10),
                  child: Image.asset('assets/route.png', width: 30, height: 30,),),
                const Padding(padding: EdgeInsets.only(right: 135),
                    child: Text('1 км',style: TextStyle(fontSize: 24),)),
                Padding(padding: const EdgeInsets.only(right: 30),
                    child: Text(_km,style: const TextStyle(fontSize: 24),)),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.only(right: 10),
                  child: Image.asset('assets/time2.png', width: 30, height: 30,),),
                const Padding(padding: EdgeInsets.only(right: 75),
                    child: Text('Ожидание',style: TextStyle(fontSize: 24),)),
                Padding(padding: const EdgeInsets.only(right: 30),
                    child: Text(_wait,style: const TextStyle(fontSize: 24),)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(padding: EdgeInsets.only(left: 60),
                    child: Text('Бесплатное\nрасстояние',style: TextStyle(fontSize: 24),)),
                Padding(padding: const EdgeInsets.only(right: 50),
                    child: Text('$_free_km км',style: const TextStyle(fontSize: 24),)),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(padding: EdgeInsets.only(left: 60),
                    child: Text('Бесплатное\nожидание',style: TextStyle(fontSize: 24),)),
                Padding(padding: const EdgeInsets.only(right: 50),
                    child: Text('$_free_wait мин',style: const TextStyle(fontSize: 24),)),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              onPressed: () async {
                prefs.setString('tarif',_selectedValue);
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Text('Сохранить'),
            ),
          )
        ],
      ),
    ))
  );
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState((){
      _selectedValue = prefs.getString('tarif') ?? 'Эконом';
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

