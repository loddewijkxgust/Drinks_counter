import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';

class DrinkTile extends StatefulWidget {
  final Drink drink;
  final Key key;
  final Function delete;

  DrinkTile({required this.drink, required this.key, required this.delete});

  @override
  _DrinkTileState createState() =>
      _DrinkTileState(drink: this.drink, key: this.key, delete: this.delete);
}

class _DrinkTileState extends State<DrinkTile> {
  final Drink drink;
  final Key key;
  final Function delete;

  _DrinkTileState({required this.drink, required this.key, required this.delete});

  @override
  Widget build(BuildContext context) {
    double fontsize = 30;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
                flex: 2,
                child: Text(drink.name, style: TextStyle(fontSize: fontsize))),
            Flexible(
                flex: 1,
                child: Text(drink.price.toString(),
                    style: TextStyle(fontSize: fontsize))),
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          drink.min();
                          drink.save();
                        });
                      }),
                  Text(drink.amount.toString(),
                      style: TextStyle(fontSize: fontsize)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        drink.plus();
                        
                        drink.save();
                      });
                    })
                ],
              ),
            ),
            Flexible(
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    delete();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}