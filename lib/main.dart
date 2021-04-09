import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/ad_helper.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/Home.dart';
import 'models/Drink.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  await Hive.initFlutter();
  Hive.registerAdapter(BarAdapter());
  Hive.registerAdapter(DrinkAdapter());
  await Hive.openBox<Bar>('bars');
  await Hive.openBox<dynamic>('Values');
  await Hive.openBox<dynamic>('settings');

  print('box opened');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(true ? 0xff00796B : 0xff009688)));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAdLoaded = false;
  Box settings = Hive.box('settings');

  late BannerAd _ad;

  @override
  void initState() {
    if (settings.get('darkMode') == null) settings.put('darkMode', (SchedulerBinding.instance?.window.platformBrightness == Brightness.dark));

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize(width: AdSize.getSmartBanner(Orientation.portrait).width, height: AdSize.fullBanner.height),
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          print('***Ad Loaded');
          setState(() => isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad load failed (code=${error.code} message=${error.message})');
          isAdLoaded = false;
          ad.dispose();
        },
      ),
    )..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settings.listenable(),
      builder: (context, box, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: MaterialApp(
                title: 'Drink counter',
                
                theme: ThemeData(
                  primaryColor: Color(0xff009688), 
                  accentColor: Color(0xffFFC107), 
                  primaryColorDark: Color(0xff00796B), 
                  colorScheme: ColorScheme.highContrastLight(primary: Color(0xffFFC107)), 
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  textTheme: TextTheme(
                    bodyText1: TextStyle(color: Colors.black, fontSize: Values.fontSize),
                  ),
                ),
                  

                darkTheme: ThemeData.dark().copyWith(
                  primaryColor: Color(0xff009688),
                  accentColor: Color(0xffFFC107),
                  primaryColorDark: Color(0xff00796B),
                  colorScheme: ColorScheme.highContrastLight(
                    primary: Color(0xffFFC107),
                  ),
                  textTheme: TextTheme(
                    bodyText1: TextStyle(color: Colors.white, fontSize: Values.fontSize),
                  ),
                ),

                
                themeMode: settings.get('darkMode') ? ThemeMode.dark : ThemeMode.light,
                routes: {
                  '/': (context) => Home(),
                },
              ),
            ),
            child!
          ],
        );
      },
      child: Container(
        height: isAdLoaded ? _ad.size.height.toDouble() : 0,
        child: AdWidget(ad: _ad),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
