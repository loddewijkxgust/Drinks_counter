import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/Home.dart';
import 'models/Drink.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(BarAdapter());
  Hive.registerAdapter(DrinkAdapter());

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
      ),
      home: Home()
    );
  }
}