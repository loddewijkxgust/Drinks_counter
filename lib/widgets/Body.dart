import 'package:drinkscounter/Settings.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/DrinkTile.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/AddDrinkForm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.bars,
    required this.bar,
  }) : super(key: key);

  final Box bars;
  final Bar bar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: (bars.isNotEmpty
          ? (bar.menu.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                        child: Center(
                          child: Text(
                            bar.menu.fold(0, (num? value, Drink drink) => value! + drink.amount * drink.price).toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: Settings.fontSize-5
                            ),
                          ),
                        ),
                      ),
                      //tileColor: Colors.teal,
                    ),
                    Expanded(
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        itemCount: bar.menu.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= bar.menu.length) {
                            return Container(
                              color: kReleaseMode ? Theme.of(context).backgroundColor : Colors.white, //tealAccent,
                              key: UniqueKey(),
                              height: 50 + 10 + 56 + 14, // Ad + space between + speed dial height + extra
                            );
                          }

                          Drink curDrink = bar.menu[index];

                          return Dismissible(

                            child: DrinkTile(
                              drink: curDrink,
                              key: curDrink.key,
                              onPressed: () => bar.save(),
                              ),

                              key: curDrink.key,
                              onDismissed: (direction) {
                                if (index < bar.menu.length) {
                                  bar.removeDrink(curDrink);
                                  bar.save();
                                }
                            },
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          bar.swap(oldIndex, newIndex);
                          bar.save();
                        },
                      ),
                    ),
                  ],
                )
              : ListTile(
                  title: Center(
                    child: TextButton(
                      child: Text(
                        '+ Add drink',
                        style: TextStyle(
                          fontSize: Settings.fontSize,
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
                    fontSize: Settings.fontSize,
                  ),
                ),
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AddBarForm(true));
                },
              ),
            )),
    );
  }
}