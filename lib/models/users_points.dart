import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPoints {
  final String? uid;
  final int points;

  UsersPoints({required this.uid, required this.points});

  factory UsersPoints.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return UsersPoints(uid: data?['uid'],
        points: data?['points']);
  }
}