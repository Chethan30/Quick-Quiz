import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';
import 'package:quixam/Students/Sdash.dart';
import 'package:quixam/Teachers/Tdash.dart';
import 'package:quixam/Misc//PasswordUtils.dart';

import 'SReg.dart';
import 'TReg.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final db = FirebaseDatabase.instance;
  String _id;
  String _password;
  String _salt;
  String _hash;
  String _sec;
  String _sem;
  String _name;
  final formkey = new GlobalKey<FormState>();

  void validateAndSubmit() async {
    PasswordUtils pu = new PasswordUtils();
    formkey.currentState.save();
    if (formkey.currentState.validate()) {
      final ref = db.reference();
      final cred = await ref
          .child("Credentials")
          .orderByChild("usn")
          .equalTo(_id)
          .once();
      final cred1 = await ref
          .child("Credentials")
          .orderByChild("fid")
          .equalTo(_id)
          .once();
      Map<dynamic, dynamic> stud = cred.value;
      Map<dynamic, dynamic> teach = cred1.value;
      if (cred.value == null && cred1.value == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("User does not exist"),
        ));
      } else {
        if (cred.value == null) {
          teach.forEach((key, value) {
            _salt = value['salt'];
            _hash = value['hash'];
            _name = value['name'];
          });
          Session_Id.setName(_name);
          Session_Id.setID(_id);
          Session_Id.settype("Teacher");
          print(Session_Id.getName());
        } else {
          stud.forEach((key, value) {
            _salt = value['salt'];
            _hash = value['hash'];
            _sec = value['sec'];
            _sem = value['sem'];
            _name = value['name'];
          });
          Session_Id.setName(_name);
          Session_Id.settype("Student");
          Session_Id.setID(_id);
          Session_Id.setSec(_sec);
          Session_Id.setSem(_sem);
        }
        if (pu.verify(_password, _salt, _hash)) {
          if (cred.value == null)
            navigateToTDash(context);
          else {
            navigateToSDash(context);
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Wrong Password"),
          ));
        }
      }
    }
    formkey.currentState.reset();
  }

  Future navigateToTReg(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TRegisteration()));
  }

  Future navigateToTDash(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TDash()));
  }

  Future navigateToSDash(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SDash()));
  }

  Future navigateToSReg(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SRegisteration()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: new AppBar(
      //     title: new Text("Login Page"),
      //     backgroundColor:
      //         Color.fromRGBO(166, 118, 51, 1)
      //     ),
      body: new Container(
          alignment: Alignment.center,
          color: Colors.purple.shade50, //TODO Body BG here
          padding: EdgeInsets.all(32),
          child: Center(
            child: new Form(
              key: formkey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new Text(
                    "QuiXam",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.deepPurple), //TODO heading color here
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                  ),
                  new TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: new InputDecoration(labelText: "USN / ID"),
                    validator: (value) => value.isEmpty
                        ? 'Please fill in the ID (Fid/USN)'
                        : null,
                    onSaved: (value) => _id = value,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                  ),
                  new TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: new InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) =>
                        value.isEmpty ? 'Please fill in the password' : null,
                    onSaved: (value) => _password = value,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 36),
                    child: new RaisedButton(
                      padding: EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: new Text(
                        "Login",
                        style: new TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: validateAndSubmit,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(14),
                  ),
                  new Row(
                    children: [
                      Expanded(
                        child: new FlatButton(
                            child: new Text(
                              "Register as Teacher",
                              style: new TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              navigateToTReg(context);
                            }),
                      ),
                      Expanded(
                        child: new FlatButton(
                            child: new Text(
                              "Register as Student",
                              style: new TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              navigateToSReg(context);
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
