import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/Home.dart';
import 'models/Drink.dart';
import 'package:flutter/services.dart';

import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ios = defaultTargetPlatform == TargetPlatform.iOS;
  var app_secret = ios ? "123cfac9-123b-123a-123f-123273416a48" : "321cfac9-123b-123a-123f-123273416a48";
  await AppCenter.start(app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

  
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(BarAdapter());
  Hive.registerAdapter(DrinkAdapter());
 // Hive.registerAdapter(UniqueKey());

  await Hive.openBox<Bar>('bars');
  await Hive.openBox<dynamic>('Values');
  print('box opened');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white
      ),
      home: Home()
    );
  }
}