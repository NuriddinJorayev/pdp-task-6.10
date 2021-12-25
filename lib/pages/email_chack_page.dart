import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:planlarim/service/email_chaker.dart';
import 'package:planlarim/widgets/flutter_toast.dart';
import 'package:planlarim/widgets/text_fields.dart';

class EmailChackPage extends StatefulWidget {
  final String id = "email_chack_page";
  final String email;
  const EmailChackPage({Key? key, required this.email}) : super(key: key);

  @override
  _EmailChackPageState createState() => _EmailChackPageState();
}

class _EmailChackPageState extends State<EmailChackPage> {
  var control = TextEditingController();
  int time = 10;
  String buttonText = "Chack";
  bool internetConnection = false;

  @override
  void initState() {
    super.initState();
     DataConnectionChecker().hasConnection.then((value) => _connection(value));
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (time == 0) {
          timer.cancel();
          return;
        }
        time--;
      });
    });
  }
  _connection(bool b){
    setState(() {
      internetConnection = b;
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size allSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        centerTitle: true,
        title: Text(
          "Enter Code",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20.0)),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: allSize.height,
          width: allSize.width,
          color: Colors.blueGrey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: (allSize.height / 2) - 100,
                  width: allSize.width,
                  decoration: BoxDecoration(
                      color: Colors.indigo[600],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "A code has been sent to your email.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "Enter that code",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        time != 0 ? "Please Wait ${time} Seconds" : '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(height: 20.0),
              TextFields_widget().build(
                  context, "Code", Icons.vpn_lock, control, SizedBox.shrink()),
              time == 0
                  ? MaterialButton(
                      color: Colors.indigo[900],
                      onPressed: () async{
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          buttonText = "wait..";
                        });
                        await DataConnectionChecker().hasConnection.then((value) => _doChack(value));

                      },
                      child: Text(buttonText,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0)))
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  _doChack(bool b) {
    _connection(b);
   if(internetConnection){
      if (control.text.isNotEmpty) {
      Navigator.of(context).pop(EmailChaker.chack(widget.email, control.text));
    } else {
      setState(() {
        buttonText = "Chack";
      });
      FlutterToastWidget.build(context, "please Enter the password", 4);
    }
   }else{
     setState(() {
       buttonText = "Try again";
     });
     FlutterToastWidget.build(context, "Chack your network", 5);
   }
  }
}
