import 'package:drinkscounter/JSONParser.dart';
import 'package:drinkscounter/Notifications/CustomNotification.dart';
import 'package:drinkscounter/Settings.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/BarDrawer.dart';
import 'package:drinkscounter/widgets/QRGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drinkscounter/widgets/DrinkTile.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:io';

import 'package:lzma/lzma.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Drink duvel = new Drink(name: 'Duvel', price: 2.7, amount: 3);
  Drink stella = new Drink(name: 'Stella', price: 1.7, amount: 8);
  Drink cara = new Drink(name: 'Cara', price: 0.2, amount: 23);
  
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();
  Bar testBar = Bar.empty();
  
  @override
  void initState() {
    try {
      bar =  bars.get( vals.get('last') ?? bars.keys.elementAt(0))!;
    } catch (e) {
      bar = Bar.empty();
      bar = new Bar(name: 'Lege bar');
    }

//    try {
//      Bar b = JSONParse.jsonToBar('{"name":"Jeugdhuis Impuls","menu":[["Stella 25",1.5],["Stella 33",1.7],["Stella 50",3],["Duvel",2],["Westmalle dubbel",2.2],["Westmalle tripel",2.2],["Ice tea",1.5]]}');
//      String s = JSONParse.barToJson(b);
//      bars.add(JSONParse.jsonToBar(s));
//    } catch(e) {
//      print('Iets mis: $e');
//    }
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    print('Home built');
    bar = bars.get(vals.get('last')) ?? Bar.empty();
    if (bars.isEmpty) {
      print('No bars');
    }
    
//    String s = '{"name":"Jeugdhuis Impuls","menu":[["Stella 25",1.5],["Stella 33",1.7],["Stella 50",3],["Duvel",2],["Westmalle dubbel",2.2],["Westmalle tripel",2.2],["Ice tea",1.5]]}';
//    var c = base64.encode(lzma.encode(utf8.encode(s)));
//    print(lzma.encode(utf8.encode(s)));
//    print(c);
//    print(utf8.decode(lzma.decode(base64.decode(c))));

    
    
    return NotificationListener<CustomNotification>(
      
      onNotification: (ntf) {
        if (ntf.notification == Notifications.update) {
          setState(() {
            print('Updated (ntf)');
          });
        }
        print('other');
        return false;
      },
      
      
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(bar.name),//Text('${bar.key}  ::  ${bar.name}'),
          centerTitle: true,
        ),
        
        
        body: bars.isNotEmpty ? (bar.menu.isNotEmpty ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title:
              Center(
                child: Text(
                  bar.menu.fold(0, (num? value, Drink drink) => value! + drink.amount * drink.price).toStringAsFixed(2)
                ),
              ),
              tileColor: Colors.teal,
            ),
            
            Expanded(
              child: ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: bar.menu.length,
                itemBuilder: (BuildContext context, int index) {
                  Drink curDrink = bar.menu[index];
                  return Dismissible(
                    onDismissed: (direction) {
                      setState(() {
                        bar.removeDrink(curDrink);
                      });
                    },
                    key: ValueKey(curDrink),
                    child: DrinkTile(
                      drink: curDrink,
                      //key: ValueKey(curDrink.key)
                      key: ValueKey(curDrink), //(new Random()).nextInt(1000000)),
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
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    final Drink d = bar.menu.removeAt(oldIndex);
                    bar.menu.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, d);
                    //bar.save();
                  });
                  },
              ),
            ),
          ],
        ) : ListTile(
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
                  builder: (BuildContext context) => AddDrinkForm(),
                );
                setState(() {});
              },
            ),
          ),
        )) : Center(
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
                builder: (BuildContext context) => AddBarForm()
              );
              setState(() {});
              },
          ),
        ),
        
  
  
  
        
        drawer: BarDrawer(),

//      bottomSheet: Container(
//        child: AdmobBanner(
//          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
//          adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: 200),
//          onBannerCreated: (a) {
//            print('Banner created');
//          },
//        ),
//        color: Colors.yellowAccent,
//      ),

      
  
        floatingActionButton:  SpeedDial(
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
                  builder: (context) => QRGenerator()
                );
                setState(() {});
              }
            ),
      
      
      
            SpeedDialChild(
              child: Icon(Icons.bug_report),
              onTap: () async {
                double fs = 20;
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      titleTextStyle: TextStyle(fontSize: 30),
                      children: [
                        Text(vals.get('err'))
                      ],
                    );
                  });
              }
            ),
          ],
        ),
      ),
    );
  }
}