import 'package:flutter/material.dart';
import 'package:learn_shared_pref/my_app.dart';
import 'package:learn_shared_pref/service/hive_service.dart';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initializeHive();
  runApp(const MyApp());
}
