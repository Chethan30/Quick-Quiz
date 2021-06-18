import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Error :("),
      ),
      body: Text("Something went wrong", textAlign: TextAlign.center, style: new TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
    );
  }
}
