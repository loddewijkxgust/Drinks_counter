import 'dart:ui';

import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/BarDrawer.dart';
import 'package:drinkscounter/widgets/QRGenerator.dart';
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


            // appBar: AppBar(
            //   title: Text(
            //     '${bar.name}', 
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: Settings.fontSizeMSmall
            //       )),
            //   centerTitle: true,

            //   bottom: PreferredSize(
            //     preferredSize: Size.fromHeight(40),
            //     child: Container(
            //       padding: EdgeInsets.only(bottom: 10),
            //       width: double.infinity,
            //       child: Text(
            //         bar.menu.fold(0, (num? value, Drink drink) => value! + drink.amount * drink.price).toStringAsFixed(2),
            //         style: TextStyle(fontSize: Settings.fontSizeMSmall),
            //       ),
            //       color: Colors.white,
            //       alignment: Alignment.bottomCenter,
            //       ),
            //     ),

            //   backgroundColor: Colors.white,
            //   iconTheme: IconThemeData(color: Colors.black),
            //   elevation: 0,
            //   actions: [
            //     PopupMenu(bars: bars, bar: bar, vals: vals),
            //     ],
            // ),

            //backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            body: Body(bars: bars, bar: bar, vals: vals),

            drawer: BarDrawer(bars: bars, bar: bar, vals: vals) ,

            floatingActionButton: SpeedDial(
              overlayOpacity: 0.4,
              icon: Icons.menu,
              backgroundColor: Theme.of(context).accentColor,
              //backgroundColor: Theme.of(context).primaryColor,
              children: [
                SpeedDialChild(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.add),
                  labelWidget: Text(
                    'Add bar',
                    style: TextStyle(
                      fontSize: Values.fontSizeSmall,
                      )),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AddDrinkForm(),
                    );
                    setState(() {});
                  },
                  //backgroundColor: Theme.of(context).colorScheme.primary,
                ),

                SpeedDialChild(
                  backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.qr_code_rounded),
                    labelWidget: Text('Share bar', style: TextStyle(
                      fontSize: Values.fontSizeSmall,
                      )),
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
