import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planlarim/pages/home_page.dart';
import 'package:planlarim/pages/sign_in_page.dart';
import 'package:planlarim/pages/sign_up_page.dart';
import 'package:planlarim/service/share_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();
  SystemChrome.setEnabledSystemUIMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: registered(),
      routes: {
        Home().id: (context) => Home(),
        SignInPage().id: (context) => SignInPage(),
        SignUpPage().id: (context) => SignUpPage(),
      },
    );
  }

  Widget registered() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, Snapshot) {
        if (Snapshot.hasData) {
          Prefs.Save(Snapshot.data!.uid);
          return Home();
        }
        return SignInPage();
      },
    );
  }
}
