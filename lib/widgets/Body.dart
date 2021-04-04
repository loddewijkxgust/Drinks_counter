import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/DrinkTile.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:drinkscounter/widgets/PopupMenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:reorderables/reorderables.dart';

class Body extends StatelessWidget {
  Body({Key? key, required this.bars, required this.bar, required this.vals}) : super(key: key);

  final Box<Bar> bars;
  final Bar bar;
  final Box vals;

  final Image img = Image.network(
    'https://therealbarman.com/wp-content/uploads/2018/08/Bar-Background.png',
    fit: BoxFit.fill,
    );


/*
Text(
                            bar.menu.fold(0, (num value, Drink drink) => value + drink.amount * drink.price).toStringAsFixed(2),
                            style: TextStyle(fontSize: Settings.fontSizeMSmall),
                          )
*/
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: (bars.isNotEmpty
          ? (bar.menu.isNotEmpty
              ? SafeArea(
                  child: CustomScrollView(
                    slivers: [


                      SliverAppBar(
                        // title: Text("eeeeeeend"),
                        centerTitle: true,
                        backgroundColor: Theme.of(context).primaryColorDark,
                        pinned: true,
                        snap: false,
                        actions: [
                          PopupMenu(bars: bars, bar: bar, vals: vals),
                        ],
                        expandedHeight: 200,

                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Theme.of(context).primaryColor
                          ),
                          centerTitle: true,
                          title: Text('${bar.name}', style: TextStyle(color: Colors.white, fontSize: Values.fontSizeMSmall)),
                          collapseMode: CollapseMode.parallax,
                        ),
                      ),



                      ReorderableSliverList(
                        delegate: ReorderableSliverChildListDelegate(
                          List.generate(bar.menu.length + 1, (index) {
                            if (index >= bar.menu.length) {
                              return Container(
                                color: Theme.of(context).scaffoldBackgroundColor, //tealAccent,
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
                      ),
                    ],
                  ),
                )
              : ListTile(
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
                ))
          : Center(
              child: TextButton(
                child: Text(
                  '+ Add bar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Values.fontSize,
                  ),
                ),
                onPressed: () async {
                  await showDialog(context: context, builder: (BuildContext context) => AddBarForm(true));
                },
              ),
            )),
    );
  }
}
