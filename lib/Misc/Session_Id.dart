import 'dart:core';

// ignore: camel_case_types
class Session_Id {
  //Stores the session info of the current user
  static String _iD;
  static String _type;
  static String _classId;
  static String _name;
  static int _tqn;
  static String _sec;
  static String _sem;
  static String _qname;
  static int _nqn;

  static void setnqn(int n){
    _nqn=n;
  }

  static int getnqn(){
    return _nqn;
  }

  static void setName(String n) {
    _name = n;
  }

  static String getName() {
    return _name;
  }

  static void setqname(String n) {
    _qname = n;
  }

  static String getqname() {
    return _qname;
  }

  static String getSec() {
    return _sec;
  }

  static String getSem() {
    return _sem;
  }

  static void setSem(String sem) {
    Session_Id._sem = sem;
  }

  static void setSec(String sec) {
    Session_Id._sec = sec;
  }

  static int getTqn() {
    return _tqn;
  }

  static void setTqn(int tot) {
    _tqn = tot;
  }

  static String getQname() {
    return _name;
  }

  static void setQname(String n) {
    _name = n;
  }

  static String getClassId() {
    return _classId;
  }

  static void setClassId(String id) {
    _classId = id;
  }

  static String getID() {
    return _iD;
  }

  static String gettype() {
    return _type;
  }

  static void setID(String iD) {
    Session_Id._iD = iD;
  }

  static void settype(String type) {
    Session_Id._type = type;
  }
}
