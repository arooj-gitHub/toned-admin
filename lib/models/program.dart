import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toned_australia/services/datetime_converter.dart';

class Program {
  String id, title, groupId;
  int status;
  DateTime? doc;

  Program({
    required this.id,
    required this.title,
    required this.groupId,
    required this.status,
    required this.doc,
  });

  factory Program.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Program(
      id: doc.id,
      title: '${map['title'] ?? ''}'.toString(),
      groupId: map['group_id'],
      status: map['status'] ?? 0,
      doc: DateTimeConverter().convert(map['doc']),
    );
  }
}
