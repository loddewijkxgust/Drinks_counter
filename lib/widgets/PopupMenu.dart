import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/CustomPopupMenuItem.dart';
import 'package:drinkscounter/widgets/HistoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PopupMenu extends StatelessWidget {
  final Box<Bar> bars;
  final Box vals;
  final Bar bar;

  PopupMenu({
    Key? key,
    required this.bars,
    required this.vals,
    required this.bar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bar bar = bars.get(vals.get('last')) ?? Bar.empty();
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry>[
        CustomPopupMenuItem(
          icon: Icons.edit,
          text: Text('Edit bar'),
          value: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AddBarForm(bars: bars, bar: bar, vals: vals, isNew: false),
            );
          },
        ),
        // CustomPopupMenuItem(
        //   icon: Icons.delete,
        //   text: Text('Delete bar'),
        //   value: () {
        //     bar.clear();
        //     bar.save();
        //   },
        // ),
        CustomPopupMenuItem(
          icon: Icons.clear_all_sharp,
          text: Text('Reset amount'),
          value: () {
            bar.clearAmount();
            bar.save();
          },
        ),
        CustomPopupMenuItem(
          icon: Icons.save,
          text: Text('Save'),
          value: () {
            bar.saveToHistory();
            bar.save();
          },
        ),
        CustomPopupMenuItem(
          icon: Icons.history,
          text: Text('History'),
          value: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryWidget(bar: bar),
              ),
            );
            //Navigator.pushNamed(context, '/history');
          },
        ),
      ],
      onSelected: (result) => (result as Function)(),
    );
  }
}
