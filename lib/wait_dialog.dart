
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class WaitDialog extends StatefulWidget {

  int time, wait, free;
  double sum = 0.0;

  WaitDialog({required this.time, required this.wait, required this.free});

  @override
  _WaitState createState() => _WaitState(time: time);

}

class _WaitState extends State<WaitDialog> {

  late Timer? timer = null;
  int time;
  _WaitState({required this.time});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(timer==null) startTimer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ожидание",
              style: TextStyle(fontSize: 24),
            ),
            Container(
              padding: const EdgeInsets.all(60),
              child: Text(getTime(widget.time)
                ,style: const TextStyle(fontSize: 40),),
            ),
            Text(widget.sum.toStringAsFixed(2),
            style: const TextStyle(fontSize: 22),),
            Container(
              padding: const EdgeInsets.all(40),
              child: ElevatedButton(onPressed: () {
                Navigator.pop(context, widget.time);
              }, child: const Text("Закончить ожидание")),
            ),
            const Padding(padding: EdgeInsets.only(top: 0),child: Text("Продолжить",
              style: TextStyle(fontSize: 24),),)
          ],
        ),
      ),
    );
  }
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.time++;
        widget.sum = ((widget.time>widget.free ? widget.time-widget.free : 0)*widget.wait)/60;
      });
    });
  }
  String getTime(int _time) {
    int _hours = _time~/3600, _mins = (_time%3600)~/60, _secs = _time%60;
    return sprintf('%02d:%02d:%02d',[_hours,_mins,_secs]);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }
}