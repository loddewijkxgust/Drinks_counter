import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'Drink.g.dart';

@HiveType(typeId: 1)
class Drink extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double price;
  @HiveField(2)
  int amount;
  @HiveField(3)
  Key key;
  
  Drink({
    this.name = 'Empty',
    this.price = 0.0,
    this.amount = 0,
    required this.key
  });

  factory Drink.copy(Drink _drink) => Drink(name: _drink.name, price: _drink.price, amount: _drink.amount, key: _drink.key);
  
  int plus() {
    if (this.amount < 999) this.amount++;
    return this.amount;
  }

  int min() {
    if (this.amount > 0) this.amount--;
    return this.amount;
  }
}