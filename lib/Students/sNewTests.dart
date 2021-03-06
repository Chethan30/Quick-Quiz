import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';
import 'package:quixam/Students/takeQuiz.dart';

class sNewTests extends StatefulWidget {
  @override
  _sNewTestsState createState() => _sNewTestsState();
}

class _sNewTestsState extends State<sNewTests> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name = Session_Id.getClassId();
  List quizzes = new List();
  List tqn = new List();

  Future navigateToQuiz(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => takeQuiz()));
  }

  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: new Container(
        height: 1000,
        color: Colors.purple.shade50,
        child: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                quizzes.clear();
                Map<dynamic, dynamic> values = snapshot.data.value["Classes"]
                        ["S" + Session_Id.getSem()][Session_Id.getSec()]
                    [Session_Id.getClassId()]["Quizzes"];
                Map<dynamic, dynamic> vals = snapshot.data.value["LeaderBoard"];
                if (values == null) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new Text(
                          "Congratulations!!! There are no new quizzes!!",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  );
                } else {
                  values.forEach((key, value) {
                    if (!(values is String)) {
                      if (!vals.containsKey(value['qname'])) {
                        quizzes.add(value['qname']);
                        tqn.add(value['Tqn']);
                      }
                    }
                  });
                  if (quizzes.length == 0)
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: new Text(
                            "Congratulations ????! There are no new quizzes!!",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    );
                  return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: quizzes.length,
                      padding: EdgeInsets.all(25),
                      itemBuilder: (BuildContext context, int index) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Colors.white,
                                  child: Container(
                                    padding: EdgeInsets.all(25),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            quizzes[index].toString(),
                                            style: new TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Session_Id.setqname(
                                        quizzes[index].toString());
                                    Session_Id.setTqn(tqn[index]);
                                    navigateToQuiz(context);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      });
                }
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
