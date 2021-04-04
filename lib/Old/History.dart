import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
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
    return WillPopScope(
      onWillPop: () async {
        if (this.current != null) {
          setState(() => this.current = null);
          return false;
        }
        return true;
      },
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                child: this.current != null
                    // Drinks
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.bar.history[this.current]?.length,
                        itemBuilder: (context, index) {
                          Drink? drink =
                              widget.bar.history[this.current]?[index];
                          return Card(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${drink?.amount} x ${drink?.name} ',
                                style: TextStyle(fontSize: Values.fontSize),
                              ),
                            ),
                          );
                        },
                      )

                    // Dates
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.bar.history.length,
                        itemBuilder: (context, index) {
                          DateTime? date = widget.bar.history.keys.toList()[index];
                          return ListTile(
                            title: Text(
                              date.toString(),
                              style: TextStyle(fontSize: Values.fontSizeSmall),
                              ),
                            //onTap: () => setState(() => this.current = date),
                            trailing: IconButton(
                              icon: Icon(Icons.restore_rounded),
                              iconSize: Values.fontSize,
                              color: Colors.black,
                              onPressed: () => widget.bar.setMenu(widget.bar.history[this.current]!),
                            ),
                          );
                        },
                      )),
          ],
        ),
      ),
    );
  }
}
