import 'package:drinkscounter/Settings.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/BarDrawer.dart';
import 'package:drinkscounter/widgets/QRGenerator.dart';
import 'package:drinkscounter/widgets/PopupMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:drinkscounter/widgets/Body.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<Bar> bars = Hive.box<Bar>('bars');
  Bar bar = Bar.empty();
  Box vals = Hive.box<dynamic>('values');
  Bar testBar = Bar.empty();
  String err1 = '';
  int err = 0;
  

  @override
  void initState() {
    try {
      bar = (bars.get(vals.get('last') ?? bars.keys.elementAt(0))!);
    } catch (e) {
      bar = Bar.empty();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([vals.listenable(), bars.listenable()]),
        builder: (context, widget) {
          bar = bars.get(vals.get('last')) ?? Bar.empty();

          return Scaffold(

            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            appBar: AppBar(
              title: Text('${bar.name}'),
              centerTitle: true,
              actions: [
                PopupMenu(bars: bars, bar: bar, vals: vals),
                ],
            ),

            body: Body(bars: bars, bar: bar),

            drawer: BarDrawer(bars: bars, bar: bar, vals: vals) ,

            floatingActionButton: SpeedDial(
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
                        builder: (context) => QRGenerator(),
                      );
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
                    PackageInfo packageInfo =
                        await PackageInfo.fromPlatform();

                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            titleTextStyle: TextStyle(fontSize: 30),
                            children: [
                              Text('Ad loaded: pass'),
                              Text('Release mode: $kReleaseMode'),
                              Text('AppName: ${packageInfo.appName}'),
                              Text('Package name: ${packageInfo.packageName}'),
                              Text('Version: ${packageInfo.version}'),
                              Text('Build Number: ${packageInfo.buildNumber}'),
                              Text('Error: $err1'),
                              Text('Error: $err'),
                            ],
                          );
                        });
                  },
                ),

                SpeedDialChild(
                    child: Icon(Icons.refresh),
                    onTap: () => setState(() {})),
              ],
            ),
          );
        });
  }
}
