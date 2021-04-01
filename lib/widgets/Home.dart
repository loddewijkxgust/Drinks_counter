import 'package:drinkscounter/Settings.dart';
import 'package:drinkscounter/ad_helper.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/BarDrawer.dart';
import 'package:drinkscounter/widgets/QRGenerator.dart';
import 'package:drinkscounter/widgets/PopupMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drinkscounter/widgets/DrinkTile.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box bars = Hive.box<Bar>('bars');
  Box vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();
  Bar testBar = Bar.empty();

  late BannerAd _ad;
  bool _isAdLoaded = false;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    _initGoogleMobileAds();
    try {
      bar = bars.get(vals.get('last') ?? bars.keys.elementAt(0))!;
    } catch (e) {
      bar = Bar.empty();
    }

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bars.keys;
    bars.values.forEach((element) {
      print(element);
    });
    return AnimatedBuilder(
        animation: Listenable.merge([vals.listenable(), bars.listenable()]),
        builder: (context, widget) {
          bar = bars.get(vals.get('last')) ?? Bar.empty();

          return Scaffold(
            bottomSheet: Container(
              width: double.infinity,
              height: _ad.size.height.toDouble(),
              alignment: Alignment.center,
              child: AdWidget(ad: _ad),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor:
                  _isAdLoaded ? Theme.of(context).primaryColor : Colors.teal,
              title: Text('${bar.name}'),
              centerTitle: true,
              actions: [PopupMenu()],
            ),
            body: Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: (bars.isNotEmpty
                  ? (bar.menu.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Center(
                                child: Text(bar.menu
                                    .fold(
                                        0,
                                        (num? value, Drink drink) =>
                                            value! + drink.amount * drink.price)
                                    .toStringAsFixed(2)),
                              ),
                              tileColor: Colors.teal,
                            ),
                            Expanded(
                              child: ReorderableListView.builder(
                                shrinkWrap: true,
                                itemCount: bar.menu.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index >= bar.menu.length) {
                                    return Container(
                                      color: kReleaseMode
                                          ? Theme.of(context).backgroundColor
                                          : Colors.white, //tealAccent,
                                      key: UniqueKey(),
                                      height: _ad.size.height.toDouble() +
                                          10 +
                                          56 +
                                          14, // Ad + space between + speed dial height + extra
                                    );
                                  }

                                  Drink curDrink = bar.menu[index];
                                  DrinkTile drinkTile = DrinkTile(
                                    drink: curDrink,
                                    key: curDrink.key,
                                    delete: () {
                                      setState(() {
                                        bar.removeDrink(curDrink);
                                        bar.save();
                                      });
                                    },
                                    min: () {
                                      setState(() {
                                        curDrink.min();
                                        bar.save();
                                      });
                                    },
                                    plus: () {
                                      setState(() {
                                        curDrink.plus();
                                        bar.save();
                                      });
                                    },
                                  );

                                  return Dismissible(
                                    onDismissed: (direction) {
                                      setState(() {
                                        if (index < bar.menu.length) {
                                          bar.removeDrink(curDrink);
                                        }
                                      });
                                    },
                                    key: drinkTile.key,
                                    child: drinkTile,
                                  );
                                },
                                onReorder: (int oldIndex, int newIndex) {
                                  bar.swap(oldIndex, newIndex);
                                  bar.save();
                                },
                              ),
                            ),
                          ],
                        )
                      : ListTile(
                          title: Center(
                            child: TextButton(
                              child: Text(
                                '+ Add drink',
                                style: TextStyle(
                                  fontSize: Settings.fontSize,
                                ),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AddDrinkForm(),
                                );
                                setState(() {});
                              },
                            ),
                          ),
                        ))
                  : Center(
                      child: TextButton(
                        child: Text(
                          '+ Add bar',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Settings.fontSize,
                          ),
                        ),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AddBarForm(true));
                          setState(() {});
                        },
                      ),
                    )),
            ),
            drawer: BarDrawer(),
            floatingActionButton: SpeedDial(
              marginBottom: _isAdLoaded ? _ad.size.height.toDouble() + 10 : 16,
              overlayOpacity: 0.4,
              icon: Icons.menu,
              backgroundColor: Theme.of(context).primaryColor,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.add),
                  label: 'Add drink',
                  labelBackgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: Settings.fontSizeSmall,
                  ),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AddDrinkForm(),
                    );
                    setState(() {});
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                ),

                SpeedDialChild(
                    child: Icon(Icons.qr_code_rounded),
                    label: 'Share bar',
                    labelBackgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: Settings.fontSizeSmall,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => QRGenerator());
                      setState(() {});
                    }),

                //if (!kReleaseMode)
                SpeedDialChild(
                  child: Icon(Icons.local_drink),
                  onTap: () {
                    setState(() {
                      bar.addDrink(new Drink(
                          name: 'Duvel',
                          price: 2.7,
                          amount: 3,
                          key: UniqueKey()));
                      bar.addDrink(new Drink(
                          name: 'Stella',
                          price: 1.7,
                          amount: 8,
                          key: UniqueKey()));
                      bar.addDrink(new Drink(
                          name: 'Cara',
                          price: 0.2,
                          amount: 283,
                          key: UniqueKey()));
                      bar.save();
                    });
                  },
                ),

                //if (!kReleaseMode)
                SpeedDialChild(
                  child: Icon(Icons.bug_report),
                  onTap: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();

                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            titleTextStyle: TextStyle(fontSize: 30),
                            children: [
                              Text('Ad loaded: $_isAdLoaded'),
                              Text('Release mode: $kReleaseMode'),
                              Text('AppName: ${packageInfo.appName}'),
                              Text('Package name: ${packageInfo.packageName}'),
                              Text('Version: ${packageInfo.version}'),
                              Text('Build Number: ${packageInfo.buildNumber}'),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          );
        });
  }

//  @override
//  void dispose() {
//    bars.close();
//    vals.close();
//    super.dispose();
//  }
}
