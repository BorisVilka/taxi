

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/Date.dart';
import 'package:taxi/date_page.dart';

class ListPage extends StatefulWidget {

  @override
  _ListState createState() => _ListState();

}

class _ListState extends State<ListPage> {

  late List<Date>? _data = [];
  var prefs;

  @override
  Widget build(BuildContext context) {
    if(prefs==null) {
      initPrefs();
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Доходы'),),
      body: ListView.builder(
          itemCount: _data!.length,
          itemBuilder: (context, ind) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DatePage(date: _data![ind])));
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            child: Text(_data![ind].date,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.start,),
                          ),
                          Container(
                            child: Text("Выполнено заказов (${_data![ind].list.length})"),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Text(sum(_data![ind]).toStringAsFixed(2),
                            style: const TextStyle(fontSize: 18,color: Colors.amber),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('list');
    setState((){
      _data = code==null ? [] : List<Date>.from(json.decode(code).map((e)=>Date.fromJson(e)).toList());
    });
  }
  double sum(Date date) {
    double ans = 0;
    for(int i = 0;i<date.list.length;i++) {
      ans+=double.parse(date.list[i].cost);
    }
    return ans;
  }
}