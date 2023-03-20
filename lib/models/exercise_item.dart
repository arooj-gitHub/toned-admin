import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseItem {
  bool isSpace, isVideo;
  TextEditingController? text, videoLink;
  // XFile? fileResource;
  // String? link;

  ExerciseItem({
    required this.isSpace,
    required this.isVideo,
    required this.text,
    required this.videoLink,
    // required this.link,
    // this.fileResource,
  });

  factory ExerciseItem.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return ExerciseItem(
      isSpace: map['is_space'],
      isVideo: map['is_video'],
      text: map['text'],
      videoLink: map['video_link'],
      // link: map['link'],
    );
  }
}


class ExerciseItemFirestore {
  bool isSpace, isVideo;
  String? text, videoLink;

  ExerciseItemFirestore({
    required this.isSpace,
    required this.isVideo,
    required this.text,
    required this.videoLink,
  });

  Map<String, dynamic> toMap() {
    return {"text": text, "is_space": isSpace, "is_video": isVideo, "video_link": videoLink};
  }

}
