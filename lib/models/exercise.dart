import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toned_australia/services/datetime_converter.dart';

class Exercise {
  String id, title, programId;
  int status;
  DateTime? doc;
  // List exerciseItems;

  Exercise({
    required this.id,
    required this.title,
    required this.programId,
    required this.status,
    required this.doc,
    // required this.exerciseItems,
  });

  factory Exercise.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id,
      title: '${map['title'] ?? ''}'.toString(),
      programId: map['program_id'],
      status: map['status'] ?? 0,
      doc: DateTimeConverter().convert(map['doc']),
      // exerciseItems: map['body'],
    );
  }
}
