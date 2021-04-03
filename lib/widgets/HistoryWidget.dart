import 'package:drinkscounter/Settings.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';

class HistoryWidget extends StatefulWidget {
  final Bar bar;
  final DateTime? date;

  HistoryWidget({
    required this.bar,
    this.date,
  });

  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bar.name + (widget.date == null ? ' history' : ': ${widget.date}')),
      ),
      body: widget.date == null
          ? Column(
              mainAxisSize: MainAxisSize.max,
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
                        style: TextStyle(fontSize: Settings.fontSizeSmall),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryWidget(
                              bar: curBar,
                              date: curBar.history.keys.toList()[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.bar.history[widget.date]?.length,
                  itemBuilder: (context, index) {
                    Drink drink = widget.bar.history[widget.date]![index];

                    return ListTile(
                      title: Text(
                        '${drink.name}: ${drink.amount}',
                        style: TextStyle(fontSize: Settings.fontSizeSmall),
                      ),
                    );

                  },
                )),
              ],
            ),
    );
  }
}
