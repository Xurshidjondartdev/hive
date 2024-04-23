import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learn_shared_pref/models/note_model.dart';

enum LocaleKey { noteKey }

@immutable
sealed class HiveService {
  static const String dbName = 'first_db';

  static late Box box;

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox(dbName);
    box = Hive.box(dbName);
  }

  ///save
  static Future<void> saveData(List<NoteModel> notes,
      {required LocaleKey key}) async {
    List<String> stringList =
        notes.map((item) => json.encode(item.toJson())).toList();
    await box.put(key.name, stringList);
  }

  ///load
  static Future<List<NoteModel>> loadData({required LocaleKey key}) async {
    List<String> stringList = await box.get(key.name) ?? <String>[];
    List<NoteModel> notes =
        stringList.map((item) => NoteModel.fromJson(jsonDecode(item))).toList();
    return notes;
  }

  ///delete
  static Future<void> clearAll({required LocaleKey key}) async {
    await box.delete(key.name);
  }
}
