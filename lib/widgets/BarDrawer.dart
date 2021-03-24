import 'dart:io';

import 'package:drinkscounter/JSONParser.dart';
import 'file:///C:/Users/Gustl/Desktop/Code/Apps/Flutter/drinks_counter3/drinks_counter/lib/Old/CustomNotification.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/QRGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/Settings.dart';
import 'package:permission_handler/permission_handler.dart';

class BarDrawer extends StatefulWidget {
  
  @override
  _BarDrawerState createState() => _BarDrawerState();
}

class _BarDrawerState extends State<BarDrawer> {
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();

  @override
  Widget build(BuildContext context) {
    print('Drawer built');
    print(bars.get(vals.get('last'))?.key);
    bar = bars.get(vals.get('last')) ?? bar;
    
    return Drawer(
  
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DrawerHeader(
            child:
            Text('Bars', style: TextStyle(fontSize: Settings.fontSize)),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bars.length,
              itemBuilder: (BuildContext context, int index) {
                Bar curBar = bars.getAt(index) ?? Bar();
                return Dismissible(
                  direction: (DismissDirection.horizontal),
                  key: ValueKey(curBar),
                  onDismissed: (direction) {
                    setState(() {
                      bars.delete(curBar.key);
                      if (bar == curBar) {
                          try {
                            bar = bars.getAt(index) ?? Bar.empty();
                          } catch (e) {
                            try {
                              bar = bars.getAt(index-1) ?? Bar.empty();
                            } catch (e) {
                              bar = Bar.empty();
                            }
                          }
                          
                          vals.put('last', bar.key);
                          //bar.save();
                      }
                    });
//                    CustomNotification(notification: Notifications.update)..dispatch(context);
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete ${curBar.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  return Navigator.of(context).pop(false);
                                });
                              },
                              child: Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop(true);
                                });
                              },
                              child: Text('Confirm')),
                          ],
                        );
                      });
                  },
                  background: Container(
                    color: Colors.redAccent,
                  ),
                  child: ListTile(
                    tileColor:
                    curBar == bar ? Colors.black12 : Colors.white,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          bars.values.elementAt(index).name,
                          softWrap: false,
                          //'${bars.keys.elementAt(index)}  ::  ${bars.values.elementAt(index).name}',
                          style: TextStyle(
                            fontSize: Settings.fontSize,
                            color: Colors.black)),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        print('Switching...');
                        print(bars.getAt(index)?.key);
                        vals.put('last', bars.getAt(index)?.key ?? bar.key);
                        Navigator.pop(context);
//                        CustomNotification(notification: Notifications.update)..dispatch(context);
                      });
                    },
                  ),
                );
              }),
          ),
          
          Container(
            height: 70,
            padding: EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              
              children: [
                
                Expanded(
                  flex: 30,
                  child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddBarForm();
                          },
                        barrierDismissible: bars.isNotEmpty
                      );
                      setState(() {
//                        CustomNotification(notification: Notifications.update)..dispatch(context);
                      });
                        //bars.add(new Bar(name: 'Impuls'));
                    },
                    child: Text('+ Add bar',
                      style: TextStyle(fontSize: Settings.fontSize)
                    ),
                  ),
                ),
                
                
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                
                
                Expanded(
                  flex: 10,
                  child: ElevatedButton(
                    onPressed: () async {
                      var cameraStatus = await Permission.camera.status;
                      if (!cameraStatus.isGranted) {
                        Permission.camera.request();
                      }

                      try {
                        Bar bar = JSONParse.strToBar(await FlutterBarcodeScanner.scanBarcode('#ff0000', 'Cancel', true, ScanMode.QR), encoded: true);
                        bars.add(bar);
                        vals.put('last', bars.keyAt(bars.length-1));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${bar.name} added'))
                        );
                      } catch (e) {
                        print('Bardrawer:183: $e}');
                      }
                      setState(() {});
//                      CustomNotification(notification: Notifications.update)..dispatch(context);
                      Navigator.pop(context);
                      
                    },
                    child: Icon(Icons.qr_code_rounded, size: Settings.fontSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
