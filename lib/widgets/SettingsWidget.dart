import 'package:drinkscounter/Values.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsWidget extends StatelessWidget {
  SettingsWidget({Key? key}) : super(key: key);
  final Box settings = Hive.box('settings');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
      ),

      body: Column(
        children: [
          SwitchListTile(
            
            title: Text('Dark mode', style: TextStyle(fontSize: Values.fontSizeMSmall)),
            value: settings.get('darkMode'), 
            onChanged: (bool val) {
              settings.put('darkMode', val);
            },
          ),
        ],
      ),
    );
  }
}