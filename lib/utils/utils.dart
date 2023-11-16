import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> getStream(String query) {
  List<String> a = query.split(":");
  if (a[0] == 'tags') {
    return FirebaseFirestore.instance
        .collection('movies')
        .where('tags', arrayContains: a[1])
        .orderBy("date", descending: true)
        .snapshots();
  } else if (a[0] == 'genre') {
    return FirebaseFirestore.instance
        .collection('movies')
        .where('category', arrayContains: a[1])
        .orderBy("date", descending: true)
        .snapshots();
  }
  return FirebaseFirestore.instance
      .collection('movies')
      .orderBy("date", descending: true)
      .snapshots();
}
