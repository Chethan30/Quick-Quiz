import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';
import 'package:quixam/Teachers/leaderboard.dart';

class sOldTests extends StatefulWidget {
  @override
  _sOldTestsState createState() => _sOldTestsState();
}

class _sOldTestsState extends State<sOldTests> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name = Session_Id.getClassId();
  List quizzes = new List();
  List quizzess = new List(); //templist

  Future navigateToLeaderboard(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => leaderboard()));
  }

  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 216, 189, 1),
      body: new Container(
        height: 1000,
        color: Color.fromRGBO(247, 216, 189, 1),
        child: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                quizzes.clear();
                quizzess.clear();
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
                          "You haven't taken any quizzes yet. :(",
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
                    if (!(values is String)) quizzess.add(value['qname']);
                  });
                  for (int i = 0; i < quizzess.length; i++) {
                    String element = quizzess[i];
                    if (vals.containsKey(element)) {
                      if (vals[element][Session_Id.getName()] != null) {
                        quizzes.add(element);
                      }
                    }
                  }
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
                                  color: Color.fromRGBO(255, 255, 255, 1),
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
                                    navigateToLeaderboard(context);
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
