
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:taxi/utils.dart';

import 'Travel.dart';

class EndDialog extends StatelessWidget {

  final Travel travel;
  var onTap;

  EndDialog({required this.travel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 70),
              child: const Text('Итог поездки',
              style: TextStyle(fontSize: 34),),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 padding: const EdgeInsets.only(right: 50),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container(
                       padding: const EdgeInsets.only(bottom: 40),
                       child: Row(
                         children: [
                           Image.asset('assets/som.png',width: 30,height: 30,),
                           Container(
                             padding: const EdgeInsets.only(left: 20,right: 80),
                             child: Text("Подача", style: getTextStyle(),
                               textAlign: TextAlign.start,),
                           ),
                         ],
                       ),
                     ),
                     Container(
                       padding: const EdgeInsets.only(bottom: 40,right: 40),
                       child: Row(
                         children: [
                           Image.asset('assets/route.png',width: 30,height: 30,),
                           Container(
                             padding: const EdgeInsets.only(left: 20),
                             child: Text('Дистанция',style: getTextStyle(),
                               textAlign: TextAlign.start,),
                           )
                         ],
                       ),
                     ),
                     Container(
                       padding: const EdgeInsets.only(bottom: 40),
                       child: Row(
                         children: [
                           Image.asset('assets/time2.png',width: 30,height: 30,),
                           Container(
                             padding: const EdgeInsets.only(left: 20),
                             child: Text('Время поездки',style: getTextStyle(),
                               textAlign: TextAlign.start,),
                           )
                         ],
                       ),
                     ),
                     Container(
                       padding: const EdgeInsets.only(bottom: 40),
                       child: Row(
                         children: [
                           Image.asset('assets/time.png',width: 30,height: 30,),
                           Container(
                             padding: const EdgeInsets.only(left: 20,right: 40),
                             child: Text('Ожидание',style: getTextStyle(),
                               textAlign: TextAlign.start,),
                           )],
                       ),
                     )
                   ],
                 ),
               ),
               Column(
                 children: [
                   Container(
                     padding: const EdgeInsets.only(bottom: 40),
                     child: Text('${travel.start} руб', style: getTextStyle(),),
                   ),
                   Container(
                     padding: const EdgeInsets.only(bottom: 40),
                     child: Text('${travel.dist} км',style: getTextStyle(),),
                   ),
                   Container(
                     padding: const EdgeInsets.only(bottom: 40),
                     child: Text(Utils.getTime(int.parse(travel.time)),style: getTextStyle(),),
                   ),
                   Container(
                     padding: const EdgeInsets.only(bottom: 40),
                     child: Text(Utils.getTime(int.parse(travel.wait)),style: getTextStyle(),),
                   )
                 ],
               )
             ],
           ),
            Center(
              child: Container(
                alignment: Alignment.center,
                child: const Text('Стоимость поездки:',style: TextStyle(fontSize: 24),),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text('${travel.cost} руб',style: const TextStyle(
                fontSize: 75,
                color: Colors.amber
              )),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Готово',style: TextStyle(fontSize: 20),))
          ],
        ),
    );
  }

  
  TextStyle getTextStyle() {
    return const TextStyle(
      fontSize: 20,
      color: Colors.amber

    );
  }
}