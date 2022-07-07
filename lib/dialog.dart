
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {

  var onTap, content;

  CustomDialog({Key? key, this.onTap, this.content});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      contentPadding: const EdgeInsets.all(30),
      content: Text(content),
      actions: [
       Padding(padding: const EdgeInsets.only(right: 30),
           child:  ElevatedButton(onPressed: (){
         Navigator.pop(context);
       }, child: const Text("Нет")),),
        Padding(padding: const EdgeInsets.only(right: 30),
          child:  ElevatedButton(onPressed:onTap,
              child: const Text("Да")),),
      ],
    );
  }

}