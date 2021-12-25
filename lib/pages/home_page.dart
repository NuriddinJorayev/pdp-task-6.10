// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:planlarim/models/post.dart';
import 'package:planlarim/pages/post_page.dart';
import 'package:planlarim/pages/sign_in_page.dart';
import 'package:planlarim/service/auth_service.dart';
import 'package:planlarim/service/rtdb_servise.dart';
import 'package:planlarim/service/share_prefs.dart';

class Home extends StatefulWidget {
  final String id = "home_page";
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> postList = [];
  Future<List<Post>>? futureList;
  bool internetIsConnection = false;

  @override
  void initState() {
    super.initState();
    _waitAndCahck();
  }

  _waitAndCahck() {
    DataConnectionChecker().hasConnection.then((value) => _load(value));
  }

  _connection(bool s) {
    setState(() {
      internetIsConnection = s;
    });
  }

  _load(bool b) async{
    _connection(b);
    if (internetIsConnection){
     setState(() {
        futureList = RTDBService.Load();
     });
    }
    FirebaseDatabase.instance.ref().onChildChanged.listen((event) {
      setState(() {});
    });
    FirebaseDatabase.instance.ref().onChildAdded.listen((event) {
      setState(() {});
    });
    FirebaseDatabase.instance.ref().onChildRemoved.listen((event) {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
     setState(() {
        futureList = RTDBService.Load();
     });

    Size allsize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "All Users",
          style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.AuthSignOut();
              Prefs.Delete();
              Navigator.of(context).pushReplacementNamed(SignInPage().id);
            },
            icon: Icon(Icons.exit_to_app_rounded, color: Colors.black),
          )
        ],
      ),
      // body
      body: Container(
        height: allsize.height,
        width: allsize.width,
        child: FutureBuilder<List<Post>>(
          future: futureList,
          builder: (context, snap) {
            if (snap.hasData && snap.data!.length > 0) {
              return SingleChildScrollView(
                child: Column(
                  children: snap.data!
                      .map((e) => _UserView(
                          e.image, e.firstname, e.lastname, e.date, e.content))
                      .toList(),
                ),
              );
            } else if (snap.hasData && snap.data!.length == 0) {
              return Center(
                child: Text(
                  "No Data",
                  style: TextStyle(fontSize: 25.0),
                ),
              );
            } else
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10.0),
                  internetIsConnection
                      ? Text("wait a few minutes ")
                      : Text("Check your network")
                ],
              );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (builder) => Post_page()));
        },
        child: Icon(Icons.add, color: Colors.black),
        elevation: 10,
      ),
    );
  }

// user view builder function
  Widget _UserView(String netImage, String name, String surname, String date,
      String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 10.0, spreadRadius: 5)
      ]),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            netImage.isNotEmpty
                ? Container(
                    height: 250.0,
                    width: double.infinity,
                    child: Image.network(netImage, fit: BoxFit.cover,
                        loadingBuilder: (context, child, prosses) {
                      return prosses == null
                          ? child
                          : Image.asset("assets/images/ic_loading.gif",
                              fit: BoxFit.cover);
                    }),
                  )
                : Container(
                    height: 250.0,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/ic_default.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${name} ${surname}",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(date,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1)),
                  Text(content,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1)),
                  SizedBox(height: 10.0)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
