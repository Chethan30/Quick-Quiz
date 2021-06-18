import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';
import 'package:quixam/Teachers/tInsideClass.dart';

class TDash extends StatefulWidget {
  @override
  _TDashState createState() => _TDashState();
}

class _TDashState extends State<TDash> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name = Session_Id.getName();
  List lists = new List();
  List classes = new List();
  List classList = new List();
  final dbRef = FirebaseDatabase.instance.reference();
  String nSem, nSec, cname;

  void validateAndSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      classList.clear();
      int cases = 0;
      try {
        nSem = "S" + nSem.toString(); //Firebase doesnt like integers
        final ds = await dbRef.child("Classes").child(nSem).once();
        Map<dynamic, dynamic> classP = ds.value;
        if (classP.containsKey(nSec)) cases++;
        classP = classP[nSec];
        if (classP.containsKey(cname)) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text("That class already exists"),
          ));
          _formKey.currentState.reset();
          cases = 9;
        } else
          cases++;
      } catch (onError) {
        print(onError);
      } finally {
        if (cases == 0) {
          //Semester does not exist
          dbRef.child("Classes").child(nSem).update({
            "sem": nSem,
            nSec: {
              "sec": nSec,
              cname: {
                "cname": cname,
                "tname": Session_Id.getName(),
              }
            }
          });
        } else if (cases == 1) {
          //Section does not exist
          dbRef.child("Classes").child(nSem).child(nSec).update({
            "sec": nSec,
            cname: {
              "cname": cname,
              "tname": Session_Id.getName(),
            }
          });
        } else if (cases == 2) {
          dbRef
              .child("Classes")
              .child(nSem)
              .child(nSec)
              .child(cname)
              .update(//Class does not exist
                  {"tname": Session_Id.getName(), "cname": cname});
        }
      }
    }
    _formKey.currentState.reset();
//    _scaffoldKey.currentState.reassemble();
    setState(() {});
  }

  Future navigateToInsideClass(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => tInsideClass()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Welcome, $_name"),
          backgroundColor: Color.fromRGBO(166, 118, 51, 1),
        ),
        body: Container(
          color: Color.fromRGBO(247, 216, 189, 1),
          padding: EdgeInsets.all(10),
          child: new Column(children: [
            Flexible(
              flex: 2,
              child: new Card(
                child: new Form(
                    key: _formKey,
                    child: Column(children: [
                      Spacer(),
                      Flexible(
                        flex: 4,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child: new TextFormField(
                                decoration:
                                    new InputDecoration(labelText: "Semester"),
                                validator: (value) => value.isEmpty
                                    ? 'Please fill in the semester'
                                    : null,
                                onSaved: (value) => nSem = value,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child: new TextFormField(
                                decoration:
                                    new InputDecoration(labelText: "Section"),
                                validator: (value) => value.isEmpty
                                    ? 'Please fill in the section'
                                    : null,
                                onSaved: (value) => nSec = value.toUpperCase(),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 6,
                              child: new TextFormField(
                                decoration: new InputDecoration(
                                    labelText: "Class Name"),
                                validator: (value) => value.isEmpty
                                    ? 'Please fill in the class name'
                                    : null,
                                onSaved: (value) => cname = value,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Spacer(),
                      Flexible(
                        flex: 5,
                        child: new RaisedButton(
                          color: Color.fromRGBO(166, 118, 51, 1),
                          onPressed: validateAndSubmit,
                          child: Text('Submit'),
                        ),
                      ),
                      Spacer(),
                    ])),
              ),
            ),
            Flexible(
              flex: 8,
              child: new Container(
                child: FutureBuilder(
                    future: dbRef.child("Classes").once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        classes.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        if (values == null) {
                          return new Text(
                            "Please add classes. You currently have '0' classes.",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          );
                        }
                        values.forEach((semester, section) {
                          if (!(section is String))
                            section.forEach((className, value) {
                              if (!(value is String))
                                value.forEach((key, teachName) {
                                  if (!(teachName is String)) if (teachName[
                                          'tname'] ==
                                      Session_Id.getName()) {
                                    classes.add({
                                      "sem": section["sem"][1],
                                      "sec": value["sec"],
                                      "cname": key,
                                    });
                                  }
                                });
                            });
                        });
                        return new ListView.builder(
                            shrinkWrap: true,
                            itemCount: classes.length,
                            padding: EdgeInsets.all(25),
                            itemBuilder: (BuildContext context, int index) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5,
                                              top: 20,
                                              right: 20,
                                              bottom: 20),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(classes[index]["cname"],
                                                    style: new TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      classes[index]["sem"],
                                                      style: new TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(classes[index]["sec"],
                                                        style: new TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Session_Id.setClassId(
                                              classes[index]["cname"]);
                                          Session_Id.setSem(
                                              classes[index]["sem"]);
                                          Session_Id.setSec(
                                              classes[index]["sec"]);
                                          navigateToInsideClass(context);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ]),
        ));
  }
}
