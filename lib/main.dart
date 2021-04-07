import 'package:drinkscounter/ad_helper.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';
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

  print('box opened');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // ignore: dead_code
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(true ? 0xff00796B : 0xff009688)));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAdLoaded = false;

  late BannerAd _ad;

  @override
  void initState() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize(
          width: AdSize.getSmartBanner(Orientation.portrait).width,
          height: AdSize.fullBanner.height),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Color(0xff009688),
              accentColor: Color(0xffFFC107),
              primaryColorDark: Color(0xff00796B),
              
              colorScheme: ColorScheme.highContrastLight(
                primary: Color(0xffFFC107)
              ),
              
              fontFamily: GoogleFonts.ubuntu().fontFamily
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Color(0xff009688),
              accentColor: Color(0xffFFC107),
              primaryColorDark: Color(0xff00796B),
              
              colorScheme: ColorScheme.highContrastLight(
                primary: Color(0xffFFC107)
              ),
            ),

            themeMode: ThemeMode.light,

            routes: {
              '/': (context) => Home(),
            },
          ),
        ),
        Container(
          height: isAdLoaded ? _ad.size.height.toDouble() : 0,
          child: AdWidget(ad: _ad),
        ),
      ],
    );
  }
}
