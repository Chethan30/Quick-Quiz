import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quixam/Misc/PasswordUtils.dart';

class SRegisteration extends StatefulWidget {
  @override
  _SRegisterationState createState() => _SRegisterationState();
}

class _SRegisterationState extends State<SRegisteration> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbRef = FirebaseDatabase.instance.reference().child("Credentials");
  String _name;
  String _usn;
  String _pass;
  String _sec;
  String _sem;
  String _email;

  void validateAndSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Registering User"),
      ));
      final cred = await dbRef.orderByChild("usn").equalTo(_usn).once();
      Map<dynamic, dynamic> values = cred.value;
      if (cred.value == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Creating User"),
        ));
        PasswordUtils pu = new PasswordUtils();
        List l1 = pu.hash(_pass);
        dbRef.push().set({
          "name": "$_name",
          "usn": "$_usn",
          "hash": l1[0],
          "salt": l1[1],
          "sec": "$_sec".toUpperCase(),
          "sem": "$_sem",
          "email": "$_email",
          "type": "Student",
        }).then((_) {
          navigateToLogin(context);
        }).catchError((onError) {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(onError)));
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("User with that USN already exists"),
        ));
      }
    }
  }

  Future navigateToLogin(context) async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Student Registration"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: new Container(
          alignment: Alignment.center,
          color: Colors.purple.shade50,
          height: 800,
          padding: EdgeInsets.all(25),
          child: new Form(
            key: _formKey,
            child: new SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Student Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.deepPurple),
                    ),
                    Container(
                      padding: EdgeInsets.all(18),
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value.isEmpty ? 'Please fill in your name' : null,
                      onSaved: (value) => _name = value,
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "USN",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value.isEmpty ? 'Please fill in your USN' : null,
                      onSaved: (value) => _usn = value,
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value.isEmpty ? 'Please fill in your password' : null,
                      autofocus: false,
                      obscureText: true,
                      onSaved: (value) => _pass = value,
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value != _pass ? 'Passwords did not match' : null,
                      autofocus: false,
                      obscureText: true,
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "Semester",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value.isEmpty ? 'Please fill in your semester' : null,
                      onSaved: (value) => _sem = value,
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "Section",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value.isEmpty ? 'Please fill in your section' : null,
                      onSaved: (value) => _sec = value,
                    ),
                    new TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: new InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple.shade300)),
                      validator: (value) =>
                          value.isEmpty ? 'Please fill in your Email' : null,
                      onSaved: (value) => _email = value,
                    ),
                    Container(
                      padding: EdgeInsets.all(18),
                    ),
                    new RaisedButton(
                      color: Colors.deepPurple,
                      onPressed: validateAndSubmit,
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
