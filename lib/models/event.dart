import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toned_australia/services/datetime_converter.dart';

class EventModel {
  String id, title, description;
  int status;
  DateTime? doc, eventDateTime;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.doc,
    required this.eventDateTime,
  });

  factory EventModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: '${map['title'] ?? ''}'.toString(),
      description: '${map['description'] ?? ''}'.toString(),
      status: map['status'] ?? 0,
      doc: DateTimeConverter().convert(map['doc']),
      eventDateTime: DateTimeConverter().convert(map['event_timestamp']),
    );
  }
}
