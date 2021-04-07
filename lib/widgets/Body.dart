import 'package:auto_size_text/auto_size_text.dart';
import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/DrinkTile.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/QRGenerator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:reorderables/reorderables.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  Body({Key? key, required this.bars, required this.bar, required this.vals}) : super(key: key) {
    _controller.addListener(() {
      currentExtent = maxExtent - _controller.offset;
      if (currentExtent < 0) currentExtent = 0.0;
      if (currentExtent > maxExtent) currentExtent = maxExtent;
      print(currentExtent);
    });
  }

  ScrollController _controller = ScrollController();
  final maxExtent = 250.0;
  double currentExtent = 0.0;
  late List<Widget> _children;

  final Box<Bar> bars;
  final Bar bar;
  final Box vals;

/*
Text(
bar.menu.fold(0, (num value, Drink drink) => value + drink.amount * drink.price).toStringAsFixed(2),
style: TextStyle(fontSize: Settings.fontSizeMSmall),
)
*/
  @override
  Widget build(BuildContext context) {
    _children = [
      Container(
        child: IconButton(
          icon: Icon(Icons.edit, color: Colors.white, size: Values.fontSizeSmall),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AddBarForm(bars: bars, bar: bar, vals: vals, isNew: false),
            );
          },
        ),
      ),
      // Container(
      //   child: IconButton(
      //     icon: Icon(Icons.save, color: Colors.white, size: Values.fontSizeSmall),
      //     onPressed: () {
      //       bar.saveToHistory();
      //       bar.save();
      //     },
      //   ),
      // ),

      Container(
          child: IconButton(
              icon: Icon(Icons.qr_code_rounded),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => QRGenerator(),
                );
              })),

      // Container(
      //   child: IconButton(
      //     icon: Icon(Icons.history, color: Colors.white, size: Values.fontSizeSmall),
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => HistoryWidget(bar: bar),
      //           ));
      //     },
      //   ),
      // ),
      Container(
        child: IconButton(
          icon: Icon(Icons.clear_all_sharp, color: Colors.white, size: Values.fontSizeMSmall),
          onPressed: () {
            bar.clearAmount();
            bar.save();
          },
        ),
      ),
      //PopupMenu(bars: bars, bar: bar, vals: vals),
    ];

    return Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.purple),
                // title: AutoSizeText('d8 qsmlfjd qsl kfj dqsfmd qsjf ldqs j fmld qj'),
                centerTitle: true,
                backgroundColor: Color(bar.color + 20), //Theme.of(context).primaryColorDark,
                pinned: true,
                snap: false,
                actions: _children,

                expandedHeight: 200,

                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: Color(bar.color)),
                  centerTitle: false,
                  title: SafeArea(
                    child: Container(
                      // color: Colors.green,
                      child: AutoSizeText(bar.name),
                    ),
                  ),
                  stretchModes: [
                    StretchMode.fadeTitle,
                  ],
                ),
              ),
              (bars.isNotEmpty
                  ? (bar.menu.isNotEmpty
                      ? ReorderableSliverList(
                          delegate: ReorderableSliverChildListDelegate(
                            List.generate(bar.menu.length + 1, (index) {
                              if (index >= bar.menu.length) {
                                return Container(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  key: UniqueKey(),
                                  height: 56 + 19,
                                );
                              }

                              Drink curDrink = bar.menu[index];

                              return Dismissible(
                                child: DrinkTile(
                                  drink: curDrink,
                                  key: curDrink.key,
                                  onPressed: () => bar.save(),
                                ),
                                direction: DismissDirection.startToEnd,
                                key: curDrink.key,
                                onDismissed: (direction) {
                                  if (index < bar.menu.length) {
                                    bar.removeDrink(curDrink);
                                    bar.save();
                                  }
                                },
                              );
                            }),
                          ),
                          onReorder: (int oldIndex, int newIndex) {
                            bar.swap(oldIndex, newIndex);
                            bar.save();
                          },
                        )
                      : SliverToBoxAdapter(
                          child: ListTile(
                            title: Center(
                              child: TextButton(
                                child: Text(
                                  '+ Add drink',
                                  style: TextStyle(
                                    fontSize: Values.fontSize,
                                  ),
                                ),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AddDrinkForm(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ))
                  : SliverToBoxAdapter(
                      child: Center(
                        child: TextButton(
                          child: Text(
                            '+ Add bar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Values.fontSize,
                            ),
                          ),
                          onPressed: () async {
                            await showDialog(context: context, builder: (BuildContext context) => AddBarForm(bars: bars, bar: bar, vals: vals, isNew: true));
                          },
                        ),
                      ),
                    ))
            ],
          ),
        ));
  }
}
