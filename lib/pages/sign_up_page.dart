import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:planlarim/animations/fade_animaton.dart';
import 'package:planlarim/pages/email_chack_page.dart';
import 'package:planlarim/pages/home_page.dart';
import 'package:planlarim/service/auth_service.dart';
import 'package:planlarim/service/email_chaker.dart';
import 'package:planlarim/service/share_prefs.dart';
import 'package:planlarim/widgets/button_builder.dart';
import 'package:planlarim/widgets/flutter_toast.dart';
import 'package:planlarim/widgets/rich_text.dart';
import 'package:planlarim/widgets/text_fields.dart';

class SignUpPage extends StatefulWidget {
  final String id = "Sign_Up_page.dart";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;
  final baseColor = Color.fromARGB(255, 81, 115, 238);
  bool isVisible = true;
  double chan = 0;
  bool isLoading = false;
  Widget emptyWidget = SizedBox.shrink();
  var control1 = TextEditingController();
  var control2 = TextEditingController();
  var control3 = TextEditingController();
  bool internetConnection = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _animation = MyFadeAnimation.anima(_controller!);
    _controller!.forward();
   
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
   
  }

  _connection(bool b) {
    setState(() {
      internetConnection = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size allSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: allSize.height,
          width: allSize.width,
          color: Colors.indigo[600],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // top container

              Container(
                height: (allSize.height / 3),
                margin: EdgeInsets.only(left: 4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45.0),
                      topLeft: Radius.circular(45.0),
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/images/ic_anim1.gif'),
                        fit: BoxFit.fill),
                    color: Colors.white),
              ),

              SizedBox(height: 4.0),
              // middle container
              Expanded(
                child: Container(
                  width: allSize.width,
                  margin: EdgeInsets.only(right: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(height: 5.0),
                      Expanded(child: Image.asset("assets/images/login.png")),
                      SizedBox(height: 10.0),
                      
                      // user name textfield 
                      MyFadeAnimation().MyAnimation(
                          TextFields_widget().build(context, "FullName",
                              Icons.person, control1, emptyWidget),
                          _controller!,
                          _animation!,
                          true),

                      SizedBox(height: 10.0),
                        // email textfield
                      MyFadeAnimation().MyAnimation(
                          TextFields_widget().build(context, "Email",
                              Icons.email_outlined, control2, emptyWidget),
                          _controller!,
                          _animation!,
                          false),

                      SizedBox(height: 10.0),
                          // password textfield
                      MyFadeAnimation().MyAnimation(
                          TextFields_widget().build(
                              context,
                              "Password",
                              Icons.vpn_key,
                              control3,
                              _VisbleWidget(),
                              isVisible),
                          _controller!,
                          _animation!,
                          true),

                      SizedBox(height: 20.0),
                      // sign up button
                      MyFadeAnimation().MyAnimation(
                          ButtonBuilder().build(
                              context, "Sign Up", isLoading, _waitAndCaheck),
                          _controller!,
                          _animation!,
                          false),
                      SizedBox(height: 20.0)
                    ],
                  ),
                ),
              ),
              RichTextWidget.build("I'm registered ", "Registere", _registere),
            ],
          ),
        ),
      ),
    );
  }

  _registere() {
    Navigator.pop(context);
  }

   _waitAndCaheck()async{
    FocusScope.of(context).requestFocus(FocusNode());
     setState(() {
        isLoading = true;
      });
     await DataConnectionChecker().hasConnection.then((value) => _chackEmail(value));
   
  }

  _chackEmail(bool b) async {
    _connection(b);
    if (internetConnection) {
      if (control1.text.isNotEmpty &&
          control2.text.isNotEmpty &&
          control3.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        EmailChaker.exist(control2.text);
        //
        bool iscorrect = await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => EmailChackPage(email: control2.text)));
        //
        if (iscorrect) {
          AuthService.AuthSignUp(control2.text, control3.text)
              .then((userid) => _doSignUp(userid));
        } else {
          setState(() {
            isLoading = false;
            FlutterToastWidget.build(context, "Your Code is incorrect", 4);
          });
        }
      } else {
        setState(() {
           isLoading = false;
        });
        FlutterToastWidget.build(context, "Fill in all of the lists ", 4);
      }
    } else {
      setState(() {
           isLoading = false;
        });
      FlutterToastWidget.build(context, "Chack your internet", 5);
    }
  }

  _doSignUp(String userid) {
    if (userid.compareTo("email-already-in-use") == 0) {
      FlutterToastWidget.build(context, "This user is already registered", 4);
      setState(() {
        isLoading = false;
      });
    } else if (userid.compareTo("The password provided is too weak") == 0) {
      FlutterToastWidget.build(
          context,
          "The password provided is too weak\nplease enter a strong password",
          6);
      control3.clear();
      setState(() {
        isLoading = false;
      });
    } else if (userid.isNotEmpty) {
      Prefs.Save(userid);
      setState(() {
        isLoading = false;
      });
      _controller!.stop();
      Navigator.pushReplacementNamed(context, Home().id);
    }
  }

  Widget _VisbleWidget() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (isVisible) {
            isVisible = false;
          } else {
            isVisible = true;
          }
        });
      },
      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off_rounded,
          color: baseColor),
    );
  }
}
