import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quixam/Misc/Session_Id.dart';

class leaderboard extends StatefulWidget {
  @override
  _leaderboardState createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
  final dbRef = FirebaseDatabase.instance.reference();
  List names = new List();
  List scores = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Session_Id.getqname()),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.purple.shade50,
        child: FutureBuilder(
          future:
              dbRef.child("LeaderBoard").child(Session_Id.getqname()).once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              names.clear();
              scores.clear();
              print(Session_Id.getqname());
              Map<dynamic, dynamic> vals = snapshot.data.value;
              if (vals == null) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: new Text(
                        "No one has attempted this quiz yet. 😥 ",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                );
              }
              vals.forEach((key, value) {
                names.add(value['sname']);
                scores.add(value['score']);
              });
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Student Name",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                          Text("Score",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple)),
                        ]),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: names.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(names[index],
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w700)),
                                  Divider(),
                                  Text(scores[index].toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
