import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quixam/Misc/PasswordUtils.dart';

class TRegisteration extends StatefulWidget {
  @override
  _TRegisterationState createState() => _TRegisterationState();
}

class _TRegisterationState extends State<TRegisteration> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference().child("Credentials");
  String _name;
  String _fid;
  String _pass;
  String _email;

  void validateAndSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Registering User"),
      ));
      final cred = await dbRef.orderByChild("fid").equalTo(_fid).once();
      Map<dynamic, dynamic> values = cred.value;
      if (cred.value == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Creating User"),
        ));
        PasswordUtils pu = new PasswordUtils();
        List l1 = pu.hash(_pass);
        dbRef.push().set({
          "name": "$_name",
          "fid": "$_fid",
          "hash": l1[0],
          "salt": l1[1],
          "email": "$_email",
          "type": "Teacher",
        }).then((_) {
          navigateToLogin(context);
        }).catchError((onError) {
          _scaffoldKey.currentState.showSnackBar((SnackBar(
            content: Text(onError.toString()),
          )));
        });
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("User with that Fid already exists"),
      ));
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
          title: Text("Faculty Registration"),
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
              padding: const EdgeInsets.all(12),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Faculty Details",
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
                        labelText: "Faculty ID",
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple.shade300)),
                    validator: (value) =>
                        value.isEmpty ? 'Please fill in your FID' : null,
                    onSaved: (value) => _fid = value,
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
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple.shade300)),
                    validator: (value) =>
                        value.isEmpty ? 'Please fill in your Email' : null,
                    onSaved: (value) => _email = value,
                  ),
                  new TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: new InputDecoration(
                        labelText: "Registeration Key",
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple.shade300)),
                    validator: (value) =>
                        value != "112233" ? 'Wrong Key' : null,
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                  ),
                  new RaisedButton(
                    color: Colors.deepPurple,
                    onPressed: validateAndSubmit,
                    child: Text('Submit',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            )),
          ),
        ));
  }
}
