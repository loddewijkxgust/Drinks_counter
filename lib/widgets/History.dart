import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class History extends StatefulWidget {
  final Bar bar;

  History({required this.bar});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime? current;
  final Box vals = Hive.box<dynamic>('values');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.bar.history.length,
            itemBuilder: (context, index) {
              Bar curBar = widget.bar;
              DateTime? date = curBar.history.keys.toList()[index];
              return ListTile(
                title: Text(
                  date.toString(),
                  style: TextStyle(fontSize: Values.fontSizeSmall),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.restore_rounded),
                    iconSize: Values.fontSize,
                    color: Colors.black,
                    onPressed: () async {

                      setState(() {
                        // widget.bar.setMenu(widget.bar.history[date]!);
                        // widget.bar.save();
                        vals.put('temp', Bar.fromHistory(curBar.history[date]!, '${curBar.name}: $date'));
                        Navigator.of(context).pop();
                      });
                    }),
              );
            },
          )),
        ],
      ),
    );
  }
}
