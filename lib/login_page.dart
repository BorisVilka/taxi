
import 'package:flutter/material.dart';
import 'package:taxi/verify_page.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<LoginPage> {
  
  TextEditingController controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            alignment: Alignment.center,
            width: 300,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Номер телефона',
                labelText: 'Номер телефона'
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPage(number: controller.text,)));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                primary: Colors.amber,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Text('Вход'),
            ),
          )
        ],
      ),
    );
  }

}