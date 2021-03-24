import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/CustomPopupMenuItem.dart';
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
        
        CustomPopupMenuItem(
          icon: Icons.edit,
          text: Text('Edit name'),
          value: PopupActions.edit,
        ),
       CustomPopupMenuItem(
         icon: Icons.delete,
         text: Text('Clear bar'),
         value: PopupActions.clear,
       ),
        CustomPopupMenuItem(
          icon: Icons.clear,
          text: Text('Reset amount'),
          value: PopupActions.empty,
        )
      ],
      
      onSelected: (result) async {
        print(result);
        switch (result) {
          case PopupActions.edit:
            await showDialog(
              context: context,
              builder: (BuildContext context) => AddBarForm(false),
            );
            break;
            
          case PopupActions.clear:
            bar.clear();
            bar.save();
            break;
          
          case PopupActions.empty:
            bar.clearAmount();
            bar.save();
            break;
        }
      },
    );
  }
}
