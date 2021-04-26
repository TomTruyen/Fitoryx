import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String fullName;
  String email;
  Timestamp time;

  User({this.uid, this.fullName, this.email, this.time});
}
