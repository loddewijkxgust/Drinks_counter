import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/BarDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  

  @override
  void initState() {
    try {
      bar = vals.get('inited') == null ? Bar.firstBar() : (bars.get(vals.get('last') ?? bars.keys.elementAt(0))!);
      vals.put('inited', 'true');
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
            key: _scaffoldKey,

            body: Body(bars: bars, bar: bar, vals: vals),

            drawer: BarDrawer(bars: bars, bar: bar, vals: vals) ,

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) => AddDrinkForm(),
                );
                setState(() {});
              },
            )
          );
        },
    );
  }
}