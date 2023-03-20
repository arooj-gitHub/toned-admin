import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toned_australia/services/datetime_converter.dart';

class ExerciseLibrary {
  String id, title, url;
  int status;
  DateTime? doc;

  ExerciseLibrary({
    required this.id,
    required this.title,
    required this.url,
    required this.status,
    required this.doc,
  });

  factory ExerciseLibrary.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return ExerciseLibrary(
      id: doc.id,
      title: '${map['title'] ?? ''}'.toString(),
      url: map['url'] ?? '',
      status: map['status'] ?? 0,
      doc: DateTimeConverter().convert(map['doc']),
    );
  }
}
