
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatefulWidget {

  String number;

  VerifyPage({required this.number});

  @override
  _VerifyState createState() => _VerifyState();

}

class _VerifyState extends State<VerifyPage> {

  TextEditingController controller = TextEditingController();
  late String id;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.number,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (user) {

        },
        verificationFailed: (exception){

        },
        codeSent: (String s,[int? i]) async {
          id = s;
        },
        codeAutoRetrievalTimeout: (s) {

        });
    return Scaffold(
      appBar: AppBar(title: Text(widget.number),),
      body: Column(

        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            alignment: Alignment.center,
            width: 300,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: 'Код подтверждения',
                  labelText: 'Код подтверждения'
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth
                    .instance
                    .signInWithCredential(PhoneAuthProvider.credential(verificationId: id, smsCode: controller.text));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context,'/home');
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                primary: Colors.amber,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Text('Подтвердить'),
            ),
          )
        ],
      ),
    );
  }

}