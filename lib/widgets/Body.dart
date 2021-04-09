import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    _children = [
      IconButton(
        color: Colors.white,
        iconSize: Values.fontSizeMSmall,
        icon: Icon(Icons.edit),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => AddBarForm(bars: bars, bar: bar, vals: vals, isNew: false),
          );
        },
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

      IconButton(
          color: Colors.white,
          iconSize: Values.fontSizeMSmall,
          icon: Icon(Icons.qr_code_rounded),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => QRGenerator(),
            );
          }),

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
      IconButton(
        color: Colors.white,
        iconSize: Values.fontSizeMSmall,
        icon: Icon(Icons.highlight_off_rounded),
        onPressed: () {
          bar.clearAmount();
          bar.save();
        },
      ),
      //PopupMenu(bars: bars, bar: bar, vals: vals),
    ];

    return Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: AutoSizeText(
                  bar.name,
                  maxLines: 2,
                  
                  overflow: TextOverflow.ellipsis,
                ),
                centerTitle: false,
                backgroundColor: Color(bar.color),
                pinned: true,
                expandedHeight: 200,
                actions: _children,
                
                

                flexibleSpace: FlexibleSpaceBar(
                  background: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '€${bar.menu.fold(0, (num value, Drink drink) => value + drink.amount * drink.price).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: Values.fontSize, color: Colors.white),
                      ),
                    ),
                  ),
                  centerTitle: false,
                  title: Text(''),
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
                                  bar: bar,
                                ),
                                direction: DismissDirection.startToEnd,
                                key: curDrink.key,
                                onDismissed: (direction) async {
                                  final Drink curDrinkCopy = Drink.copy(bar.menu[index]);
                                  bar.removeDrink(curDrink);
                                  bar.save();

                                  await ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.fixed,
                                          content: Text('${curDrink.name} removed'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              try {
                                                bar.addDrinkAt((index <= bar.menu.length) ? index : bar.menu.length, curDrinkCopy);
                                              } catch (e) {
                                                print('****fout: $e');
                                              }
                                              bar.save();
                                              print('koeroekoeroekoeroekoeroekoeroekoeroe');
                                            },
                                          ),
                                        ),
                                      )
                                      .closed
                                      .then((reason) {
                                    if (reason != SnackBarClosedReason.action) {
                                    }
                                  });
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
                                  style: Theme.of(context).textTheme.bodyText1,
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
                          child: Text('+ Add bar', style: Theme.of(context).textTheme.bodyText1),
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
/*
Container(
                    color: Color(bar.color),
                    child: SafeArea(
                      child: Container(
                        // color: Colors.blueGrey,
                        height: double.infinity,
                        padding: EdgeInsets.only(right: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                // alignment: Alignment.bottomLeft,
                                color: Colors.yellow,
                                child: AutoSizeText(
                                  bar.name,
                                  softWrap: true,
                                  wrapWords: false,
                                  style: TextStyle(backgroundColor: Colors.orange),
                                ),
                              ),
                            ),
                            ..._children.map((element) {
                              return Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 0),
                                  child: element,
                                  // alignment: Alignment.centerRight,
                                  color: Colors.green,
                                  margin: EdgeInsets.all(1),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  )*/
