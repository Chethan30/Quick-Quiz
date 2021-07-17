import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';

class createQuiz extends StatefulWidget {
  @override
  _createQuizState createState() => _createQuizState();
}

class _createQuizState extends State<createQuiz> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbRef = FirebaseDatabase.instance.reference();
  List<TextEditingController> qnc =
      new List.generate(Session_Id.getTqn(), (_) => TextEditingController());
  List<TextEditingController> opac =
      new List.generate(Session_Id.getTqn(), (_) => TextEditingController());
  List<TextEditingController> opbc =
      new List.generate(Session_Id.getTqn(), (_) => TextEditingController());
  List<TextEditingController> opcc =
      new List.generate(Session_Id.getTqn(), (_) => TextEditingController());
  List<TextEditingController> opdc =
      new List.generate(Session_Id.getTqn(), (_) => TextEditingController());
  List<TextEditingController> corrc =
      new List.generate(Session_Id.getTqn(), (_) => TextEditingController());
  List corr = new List.generate(Session_Id.getTqn(), (_) => null);
  String dropdownValue = 'Select';

  Widget question(int index) {
    return Card(
      elevation: 3,
      shadowColor: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      (index + 1).toString() + ")",
                      style: new TextStyle(fontSize: 20),
                    )),
                Expanded(
                  flex: 12,
                  child: TextFormField(
                    decoration: new InputDecoration(labelText: "Question"),
                    validator: (value) =>
                        value.isEmpty ? 'Please the Question' : null,
                    controller: qnc[index],
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: new InputDecoration(
                  labelText: "Option A",
                  labelStyle: TextStyle(fontStyle: FontStyle.italic)),
              validator: (value) =>
                  value.isEmpty ? 'Please enter option A' : null,
              controller: opac[index],
            ),
            TextFormField(
              decoration: new InputDecoration(
                  labelText: "Option B",
                  labelStyle: TextStyle(fontStyle: FontStyle.italic)),
              validator: (value) =>
                  value.isEmpty ? 'Please enter option B' : null,
              controller: opbc[index],
            ),
            TextFormField(
              decoration: new InputDecoration(
                  labelText: "Option C",
                  labelStyle: TextStyle(fontStyle: FontStyle.italic)),
              validator: (value) =>
                  value.isEmpty ? 'Please enter option C' : null,
              controller: opcc[index],
            ),
            TextFormField(
              decoration: new InputDecoration(
                  labelText: "Option D",
                  labelStyle: TextStyle(fontStyle: FontStyle.italic)),
              validator: (value) =>
                  value.isEmpty ? 'Please enter option D' : null,
              controller: opdc[index],
            ),
            Row(
              children: [
                Radio(
                    value: "a",
                    groupValue: corr[index],
                    onChanged: (value) {
                      setState(() {
                        corr[index] = value;
                      });
                    }),
                Text("A"),
                SizedBox(
                  width: 20,
                ),
                Radio(
                    value: "b",
                    groupValue: corr[index],
                    onChanged: (value) {
                      setState(() {
                        corr[index] = value;
                      });
                    }),
                Text("B"),
                SizedBox(
                  width: 20,
                ),
                Radio(
                    value: "c",
                    groupValue: corr[index],
                    onChanged: (value) {
                      setState(() {
                        corr[index] = value;
                      });
                    }),
                Text("C"),
                SizedBox(
                  width: 20,
                ),
                Radio(
                    value: "d",
                    groupValue: corr[index],
                    onChanged: (value) {
                      setState(() {
                        corr[index] = value;
                      });
                    }),
                Text("D"),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(Session_Id.getqname()),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          color: Colors.purple.shade50,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: Session_Id.getTqn(),
                  itemBuilder: (BuildContext context, int index) {
                    return question(index);
                  },
                ),
              ),
              RaisedButton(
                color: Colors.deepPurple,
                child: Text(
                  "Create Quiz!",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () {
                  String sem = "S" + Session_Id.getSem();
                  String sec = Session_Id.getSec();
                  String classn = Session_Id.getClassId();
                  var json = {};
                  for (int i = 0; i < Session_Id.getTqn(); i++) {
                    json.addAll({
                      "Q" + (i + 1).toString(): {
                        "qn": qnc[i].value.text,
                        "opa": opac[i].value.text,
                        "opb": opbc[i].value.text,
                        "opc": opcc[i].value.text,
                        "opd": opdc[i].value.text,
                        "corr": corr[i],
                      }
                    });
                  }
                  print(corr);
                  dbRef
                      .child("Classes")
                      .child(sem)
                      .child(sec)
                      .child(classn)
                      .child("Quizzes")
                      .push()
                      .set({
                    "qname": Session_Id.getqname(),
                    "Tqn": Session_Id.getTqn(),
                  });
                  dbRef.child("Quizzes").child(Session_Id.getqname()).set(json);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }
}
