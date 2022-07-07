
import 'package:flutter/material.dart';
import 'package:taxi/Date.dart';
import 'package:taxi/end_dialog.dart';
import 'package:taxi/utils.dart';

class DatePage extends StatelessWidget {

  final Date date;

  DatePage({required this.date});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(date.date),),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: const Text("Итог",style: TextStyle(color: Colors.amber),),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              alignment: Alignment.center,
              child: Text(sum(date).toStringAsFixed(2),
                style: const TextStyle(fontSize: 36,color: Colors.amber),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 30),
                        child: const Text('Выполнено заказов', textAlign: TextAlign.start,),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 30),
                        child: const Text('Пробег', textAlign: TextAlign.start,),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 30),
                        child: const Text('За рулем', textAlign: TextAlign.start,),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text('${date.list.length}', textAlign: TextAlign.end,),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(distTotal(date).toStringAsFixed(3), textAlign: TextAlign.end,),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(Utils.getTime(timeTotal(date)), textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child:  ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context,ind) {
                  return GestureDetector(
                    onTap: (){
                      showGeneralDialog(context: context, pageBuilder: (a,b,c){
                        return EndDialog(travel: date.list[ind], onTap: () {

                        });
                      });
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Text("${date.list[ind].dist} км"),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            child: Text(date.list[ind].cost,
                              style: const TextStyle(fontSize: 18,color: Colors.amber),),
                          )
                        ],
                      ),
                    ),
                  );
                } ,
                itemCount: date.list.length,
              ),
            )
          ],
        ),
      )
    );
  }


  double sum(Date date) {
    double ans = 0;
    for(int i = 0;i<date.list.length;i++) {
      ans+=double.parse(date.list[i].cost);
    }
    return ans;
  }
  double distTotal(Date date) {
    double ans = 0;
    for(int i = 0;i<date.list.length;i++) {
      ans+=double.parse(date.list[i].dist);
    }
    return ans;
  }
  int timeTotal(Date date) {
    int ans = 0;
    for(int i = 0;i<date.list.length;i++) {
      ans+=int.parse(date.list[i].time);
    }
    return ans;
  }
}