// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planlarim/models/post.dart';
import 'package:planlarim/service/rtdb_servise.dart';
import 'package:planlarim/service/share_prefs.dart';
import 'package:planlarim/service/storage_service.dart';
import 'package:planlarim/widgets/appbar1widget.dart';
import 'package:planlarim/widgets/flutter_toast.dart';
import 'package:planlarim/widgets/grey_textField.dart';

class Post_page extends StatefulWidget {
  const Post_page({Key? key}) : super(key: key);

  @override
  _Post_pageState createState() => _Post_pageState();
}

class _Post_pageState extends State<Post_page> {
  var control1 = TextEditingController();
  var control2 = TextEditingController();
  var control3 = TextEditingController();
  var control4 = TextEditingController();
  bool internetConnection = false;
  File? _imageFile;
  bool isLoading = false;
  String buttontext = "Sent";
  @override
  void initState() {
    super.initState();
    DataConnectionChecker().hasConnection.then((value) => _connection(value));
  }

  _connection(bool b) {
    setState(() {
      internetConnection = b;
      print(b);
    });
  }
 

  @override
  Widget build(BuildContext context) {
    Size allSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBAr1Widget.Appbar(() {
        if (!isLoading) {
          Navigator.of(context).pop();
        }
      }, "Add Post", () {}),
      body: SingleChildScrollView(
        child: Container(
          height: allSize.height - 100,
          width: allSize.width,
          child: !isLoading
              ? Column(
                  children: [
                    SizedBox(height: 10.0),
                    // round top rounded panel
                    Container(
                      height: allSize.height / 6,
                      width: allSize.width / 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // image panel
                          _imageFile != null
                              ? Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.pink[900]!, width: 5.0),
                                      image: DecorationImage(
                                          image: FileImage(_imageFile!),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.pink[900]!, width: 5.0),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/ic_default.jpg"),
                                          fit: BoxFit.cover)),
                                ),

                          // image picker button panel
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Transform.translate(
                              offset: Offset(8.0, 20.0),
                              child: GestureDetector(
                                onTap: _getImageFile,
                                child: Container(
                                  height: 65.0,
                                  width: 65.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/ic_camera.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 4.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // base panel
                    SizedBox(height: 40.0),
                    GreyTextFieldWidget.build("First Name", control1),
                    SizedBox(height: 10.0),
                    GreyTextFieldWidget.build("Last Name", control2),
                    SizedBox(height: 10.0),
                    GreyTextFieldWidget.build("date", control3),
                    SizedBox(height: 10.0),
                    GreyTextFieldWidget.build("Content", control4),
                    SizedBox(height: 40.0),
                    // sent button
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          buttontext = "Wait..";
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                       await DataConnectionChecker()
                            .hasConnection
                            .then((value) => _waitAndCaheck(value));
                      },
                      child: Container(
                        height: 50.0,
                        width: 100.0,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(colors: [
                              Colors.indigo[900]!,
                              Colors.pink[900]!,
                            ])),
                        child: Center(
                            child: Text(buttontext,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                )
              : Container(
                  height: allSize.height,
                  width: allSize.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.indigo[900]!, Colors.pink[900]!]),
                  ),
                  child: Center(
                      child: Image.asset("assets/images/ic_loading.gif",
                          fit: BoxFit.cover)),
                ),
        ),
      ),
    );
  }

  _waitAndCaheck(bool b) {
    _connection(b);
    if (internetConnection) {
      if (control1.text.isNotEmpty &&
          control2.text.isNotEmpty &&
          control3.text.isNotEmpty &&
          control4.text.isNotEmpty) {
        setState(() {
          isLoading = true;
          buttontext = "Sent";
        });
        if (_imageFile != null) {
          StorageService.SetImage(_imageFile!).then((value) => _addPost(value));
        } else {
          _addPost("");
        }
      } else {
        FlutterToastWidget.build(context, "you must complete all lists", 4);
        setState(() {
        isLoading = false;
        buttontext = "Sent";
      });
      }
    } else {
      FlutterToastWidget.build(context, "Chack your network", 5);
      setState(() {
        isLoading = false;
        buttontext = "Try gain";
      });
    }
  }

  _addPost(String url) async {
    String id = await Prefs.Load();
    var p = Post(
        control1.text, control2.text, control3.text, control4.text, id, url);
    RTDBService.setSave(p);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  _getImageFile() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }
}
