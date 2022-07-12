import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:my_video_log/components/domains/log_record.dart';
import 'package:my_video_log/service/user_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class VideoLogService {
  final _storageRef = FirebaseStorage.instance.ref();
  final _sl = GetIt.instance;
  final _db = FirebaseFirestore.instance;

  Future<Uint8List?> getThumbnail(String videoFile) async {
    return await VideoThumbnail.thumbnailData(
      video: videoFile,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
  }

  Future<String?> upload(Uint8List data, String dir, String file) async {
    try {
      final uid = _sl.get<UserService>().getUser()!.uid;
      final imgRef = _storageRef.child('$dir/$uid/$file');
      await imgRef.putData(data);
      String url = await imgRef.getDownloadURL();
      return url;
    } catch(e) {
      if (kDebugMode) {
        print("upload error");
        print(e);
      }

    }
    return null;
  }

  Future<String?> uploadFile(String filePath, String dir, String fileName) async {
    try {
      final uid = _sl.get<UserService>().getUser()!.uid;
      final videoRef = _storageRef.child('$dir/$uid/$fileName');
      await videoRef.putFile(File(filePath));
      String url = await videoRef.getDownloadURL();
      return url;
    } catch(e) {
      if (kDebugMode) {
        print("upload video error");
        print(e);
      }

    }
    return null;
  }

  initLogRecord() async {
    final uid = _sl.get<UserService>().getUser()!.uid;
    final doc = await _db.collection('video_logs').doc(uid).get();
    if(doc.data() == null) {
      _db.collection('video_logs/').doc(uid).set({
        'logs': []
      });
    }
  }

  addVideoLogRecord(String videoPath, DateTime date, {bool uploadToCloud = false}) async {
      Uint8List? thumbnail = await getThumbnail(videoPath);
      String id = const Uuid().v4();
      String? downloadUrl = await upload(thumbnail!,"thumbnails", "$id.jpeg");
      String? videoUrl ;
      if(uploadToCloud) {
        videoUrl= await uploadFile(videoPath, "videos", basename(videoPath));
      }

      final uid = _sl.get<UserService>().getUser()!.uid;
      final record = <String, dynamic> {
        "id":id,
        "uid": uid,
        "downloadUrl": downloadUrl!,
        "date": date,
        "videoPath": videoPath,
        "videoUrl": videoUrl,
      };
      try {
        _db.collection('video_logs/').doc(uid).update(
          {
            "logs": FieldValue.arrayUnion([record])
          }
        );
      } catch(error) {
        if(kDebugMode) {
          print("add record error");
          print(error);
        }
      }
  }

  removeRecord(String recordId) async {
    final uid = _sl.get<UserService>().getUser()!.uid;

    final data = await _db.collection('video_logs').doc(uid).get();
    final videoLogs = data.data() as Map<String, dynamic>;

    final records = videoLogs['logs'] as List<dynamic>;
    records.removeWhere((element) => element['id'] == recordId);
    try {
      _db.collection('video_logs/').doc(uid).update(
          {
            'logs': records
          }
      );
    } catch(error) {
      if(kDebugMode) {
        print("add record error");
        print(error);
      }
    }
  }

  Future<List<LogRecord>> loadRecords() async {
    final uid = _sl.get<UserService>().getUser()!.uid;
    final data = await _db.collection('video_logs').doc(uid).get();
    final videoLogs = data.data() as Map<String, dynamic>;

    final records = videoLogs['logs'] as List<dynamic>;
    return records.map((e) => LogRecord(id: e['id'], date: e['date'].toDate(), videoPath: e['videoPath'],
        thumbnailUrl: e['downloadUrl'],
        videoUrl : e['videoUrl'])).toList();
  }

  loadRecordsByDate() async {
    List<LogRecord> records = await loadRecords();
    final formatter = DateFormat('yyyy-MM-dd');
    return groupBy(records, (LogRecord r) => formatter.format(r.date));
  }

}