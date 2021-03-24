import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PopupMenu extends StatelessWidget {
  final Box bars = Hive.box<Bar>('bars');
  final Box vals = Hive.box<dynamic>('values');
  
  @override
  Widget build(BuildContext context) {
    Bar bar = bars.get(vals.get('last')) ?? Bar.empty();
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: Text('Edit name'),
          value: Actions.edit
        ),
        PopupMenuItem(
          child: Text('Clear bar'),
          value: Actions.clear
        ),
        PopupMenuItem(
          child: Text('Reset amount'),
          value: Actions.empty,
        )
      ],
      onSelected: (result) async {
        switch (result) {
          case Actions.edit:
            await showDialog(
              context: context,
              builder: (BuildContext context) => AddBarForm(false),
            );
            break;
            
          case Actions.clear:
            bar.clear();
            bar.save();
            break;
          
          case Actions.empty:
            bar.clearAmount();
            bar.save();
            break;
        }
      },
    );
  }
}

enum Actions {
  edit,
  empty,
  clear
}