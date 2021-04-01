import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  Bar bar;
  DateTime? current;

  History({required this.bar});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.current != null) {
          setState(() => widget.current = null);
          return false;
        }
        return true;
      },
      child: Dialog(
        child: widget.current != null
            // Drinks
            ? ListView.builder(
                itemCount: widget.bar.history?[widget.current]?.length,
                itemBuilder: (context, index) {
                  Drink? drink = widget.bar.history?[widget.current]?[index];
                  return Card(
                    child: Text('${drink?.name} : ${drink?.amount}'),
                  );
                },
              )
            // Dates
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.bar.history?.length,
                itemBuilder: (context, index) {
                  DateTime? date = widget.bar.history?.keys.toList()[index];
                  return ListTile(
                    title: Text(date.toString()
                        //'${date?.day}/${date?.month}/${date?.year}',
                        ),
                    onTap: () async {
                      setState(() {
                        widget.current = date;
                      });
                    },
                  );
                }),
      ),
    );
  }
}
