// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planlarim/animations/fade_animaton.dart';
import 'package:planlarim/pages/home_page.dart';
import 'package:planlarim/pages/sign_up_page.dart';
import 'package:planlarim/service/auth_service.dart';
import 'package:planlarim/service/share_prefs.dart';
import 'package:planlarim/widgets/button_builder.dart';
import 'package:planlarim/widgets/flutter_toast.dart';
import 'package:planlarim/widgets/page_indicator.dart';
import 'package:planlarim/widgets/rich_text.dart';
import 'package:planlarim/widgets/text_fields.dart';

class SignInPage extends StatefulWidget {
  final String id = "Sign_in_page.dart";
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;
  final baseColor = Color.fromARGB(255, 81, 115, 238);
  final firstColor = Color.fromARGB(255, 86, 139, 249);
  final secondColor = Color.fromARGB(255, 75, 92, 224);
  final pageControl = PageController();
  bool internetConnection = false;

  var control1 = TextEditingController();
  var control2 = TextEditingController();

  bool isvisible = true;
  Widget emptyWidget = SizedBox.shrink();
  int pageindecatorIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _animation = MyFadeAnimation.anima(_controller!);
    _controller!.forward();
     
  }

  _connection(bool b) {
    setState(() {
      internetConnection = b;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size allSize = MediaQuery.of(context).size;  

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
          child: SingleChildScrollView(
        child: SizedBox(
          height: allSize.height,
          width: allSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // top contaioner
              Container(
                height: (allSize.height / 2) - 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45.0),
                      bottomRight: Radius.circular(45.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // top panel pageview
                    Expanded(
                      child: PageView(
                        controller: pageControl,
                        scrollBehavior: ScrollBehavior(
                            androidOverscrollIndicator:
                                AndroidOverscrollIndicator.stretch),
                        onPageChanged: (int index) {
                          setState(() {
                            pageindecatorIndex = index;
                          });
                        },
                        children: [
                          Image.asset("assets/images/ic_image1.png"),
                          Image.asset("assets/images/ic_image2.png"),
                          Image.asset("assets/images/ic_image3.png"),
                        ],
                      ),
                    ),
                    PageIndicatorWidget.build(pageindecatorIndex, 500),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),

              // base widets start
              SizedBox(height: 20.0),
              Icon(Icons.person, color: baseColor, size: 60.0),
              SizedBox(height: 5.0),

              // with animation and textfield

              MyFadeAnimation().MyAnimation(
                  TextFields_widget().build(context, "Enter your Email",
                      Icons.email_outlined, control1, emptyWidget),
                  _controller!,
                  _animation!,
                  true),

              SizedBox(height: 8.0),

              // with animation and textfield

              MyFadeAnimation().MyAnimation(
                  TextFields_widget().build(context, "Enter your Password",
                      Icons.vpn_key, control2, visibleWidget(), isvisible),
                  _controller!,
                  _animation!,
                  false),

              SizedBox(height: 12.0),

              // base widgets and
              MyFadeAnimation().MyAnimation(
                  ButtonBuilder()
                      .build(context, "Sign In", isLoading, _waitAndCaheck),
                  _controller!,
                  _animation!,
                  true),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RichTextWidget.build(
                        "Not registered", "To Register", _toRegister)),
              )
            ],
          ),
        ),
      )),
    );
  }

  // open toRegister page
  _toRegister() {
    Navigator.of(context).pushNamed(SignUpPage().id);
  }
  //internet chacker
  _waitAndCaheck()async{
    FocusScope.of(context).requestFocus(FocusNode());
     setState(() {
        isLoading = true;
      });
     await DataConnectionChecker().hasConnection.then((value) => _signInFunction(value));
   
  }
  // internet chacker and sign in
  _signInFunction(bool b){
    _connection(b);
    String email = control1.text;
    String password = control2.text;

    if (internetConnection) {
      if (email.isNotEmpty && password.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        AuthService.AuthSignIn(email, password)
            .then((value) => _authChacker(value));
      } else {
         setState(() {
        isLoading = false;
      });
        FlutterToastWidget.build(context, "Chack your Email or password", 4);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      FlutterToastWidget.build(context, "Chack your internet", 5);
    }
  }

  // auth chaker
  _authChacker(User? user) {
    if (user != null) {
      Prefs.Save(user.uid);
      setState(() {
        isLoading = false;
      });
      _controller!.stop();
      Navigator.pushReplacementNamed(context, Home().id);
    } else {
      setState(() {
        isLoading = false;
      });
      FlutterToastWidget.build(context, "Email or password incorrect", 4);
    }
  }

  // textfield sufficon widget
  Widget visibleWidget() {
    return IconButton(
        onPressed: () {
          setState(() {
            if (isvisible) {
              isvisible = false;
            } else {
              isvisible = true;
            }
          });
        },
        icon: Icon(
            isvisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: baseColor));
  }
}
