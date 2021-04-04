import 'package:drinkscounter/Values.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrinkTile extends StatefulWidget {
  final Drink drink;
  final Key key;
  final Function onPressed;

  DrinkTile({
    required this.drink,
    required this.key,
    required this.onPressed,
  });

  @override
  _DrinkTileState createState() => _DrinkTileState();
}

class _DrinkTileState extends State<DrinkTile> {
  @override
  Widget build(BuildContext context) {
    double fontsize = Values.fontSize-5;
    return Card(
      elevation: 0,
      //margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Text(
                widget.drink.name,
                style: TextStyle(fontSize: fontsize),
                maxLines: 2,
              )
            ),

            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Text(widget.drink.price.toStringAsFixed(2),
                style: TextStyle(fontSize: fontsize))),
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Icon(Icons.remove),
                    onPressed: () {
                      widget.drink.min();
                      widget.onPressed();
                    },
                    style: TextButton.styleFrom(
                      //backgroundColor: Colors.tealAccent,
                      padding: EdgeInsets.all(0),
                    )
                  ),
                  
                  Container(
                    //color: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      widget.drink.amount.toString(),
                      style: TextStyle(fontSize: fontsize)),
                  ),
                  
                  TextButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      widget.drink.plus();
                      widget.onPressed();
                    },
                    style: TextButton.styleFrom(
                      //backgroundColor: Colors.tealAccent,
                      padding: EdgeInsets.all(0),
                    )
                  )
                ],
              ),
            ),
//            Flexible(
//
//              child: IconButton(
//                icon: Icon(Icons.delete),
//                onPressed: () {
//                  delete();
//                },
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

