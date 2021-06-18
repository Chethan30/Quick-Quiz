import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';

class takeQuiz extends StatefulWidget {
  @override
  _takeQuizState createState() => _takeQuizState();
}

class _takeQuizState extends State<takeQuiz> {
  final dbRef = FirebaseDatabase.instance.reference();
  List question = new List();
  List opa = new List();
  List opb = new List();
  List opc = new List();
  List opd = new List();
  List selected = new List.generate(Session_Id.getTqn(), (_) => null);
  List corr = new List();

  Widget format(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(children: [
            Expanded(
                flex: 1,
                child: Text(
                  (index + 1).toString() + ")",
                  style: new TextStyle(fontSize: 20),
                )),
            Expanded(
              flex: 12,
              child: Text(question[index]),
            ),
          ]),
          Row(
            children: [
              Radio(
                value: "a",
                groupValue: selected[index],
                onChanged: (value) {
                  setState(() {
                    selected[index] = value;
                  });
                },
              ),
              Text(
                opa[index],
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: "b",
                groupValue: selected[index],
                onChanged: (value) {
                  setState(() {
                    selected[index] = value;
                  });
                },
              ),
              Text(
                opb[index],
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: "c",
                groupValue: selected[index],
                onChanged: (value) {
                  setState(() {
                    selected[index] = value;
                  });
                },
              ),
              Text(
                opc[index],
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: "d",
                groupValue: selected[index],
                onChanged: (value) {
                  setState(() {
                    selected[index] = value;
                  });
                },
              ),
              Text(
                opd[index],
              )
            ],
          ),
        ]),
      ),
    );
  }

  void submit() {
    int total = 0;
    for (int i = 0; i < Session_Id.getTqn(); i++) {
      if (corr[i] == selected[i]) total++;
    }
    dbRef
        .child("LeaderBoard")
        .child(Session_Id.getqname())
        .child(Session_Id.getName())
        .set({
      'sname': Session_Id.getName(),
      'score': total,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Session_Id.getqname()),
        backgroundColor: Color.fromRGBO(166, 118, 51, 1),
      ),
      backgroundColor: Color.fromRGBO(247, 216, 189, 1),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: FutureBuilder(
                  future: dbRef
                      .child("Quizzes")
                      .child(Session_Id.getqname())
                      .once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      opa.clear();
                      opb.clear();
                      opc.clear();
                      opd.clear();
                      question.clear();
                      Map<dynamic, dynamic> values = snapshot.data.value;
                      values.forEach((key, value) {
                        opa.add(value['opa']);
                        opb.add(value['opb']);
                        opc.add(value['opc']);
                        opd.add(value['opd']);
                        question.add(value['qn']);
                        corr.add(value['corr']);
                      });
                      return ListView.builder(
                          itemCount: Session_Id.getTqn(),
                          itemBuilder: (BuildContext context, int index) {
                            return format(index);
                          });
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
            RaisedButton(
              child: Text("Submit"),
              onPressed: submit,
            )
          ],
        ),
      ),
    );
  }
}
