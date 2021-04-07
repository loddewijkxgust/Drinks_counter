import 'dart:convert';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lzma/lzma.dart';
part 'Bar.g.dart';

@HiveType(typeId: 2)
class Bar extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Drink> menu;
  @HiveField(2)
  Map<DateTime, List<Drink>> history = Map<DateTime, List<Drink>>();
  @HiveField(3)
  int color;

  Bar({
    this.name = 'Empty',
    this.menu = const [],
    this.color = 0xffff3a28, //0xff009688
  });

  Bar.fromString({
    required String string,
    encoded = false,
    this.name = 'Empty',
    this.menu = const [],
    this.color = 0,
  }) {
    string = encoded ? utf8.decode(lzma.decode(base64.decode(string))) : string;
    Map<String, dynamic> json = jsonDecode(string);
    this.name = json['name'];
    this.color = int.parse(json['color'].toString());
    json['menu'].forEach((item) {
      this.addDrink(new Drink(
        name: item[0],
        price: double.parse(item[1].toString()),
        key: UniqueKey(),
      ));
    });
  }

  factory Bar.empty() => Bar(name: '', color: 0xFF009688);
  factory Bar.firstBar() => Bar(name: 'My first bar', color: 0xFF48d4ff);
  factory Bar.fromHistory(List<Drink> _menu, String _name) => Bar(menu: _menu, name: _name);

  String toString({encoded = false}) {
    String str = this.menu.fold('{"name":"${this.name}","color":"${this.color}","menu":[', (String str, Drink drink) => str + '["${drink.name}",${drink.price}],').replaceAll(RegExp(r'.$'), "") + ']}';
    return encoded ? base64.encode(lzma.encode(utf8.encode(str))) : str;
  }

  void setMenu(List<Drink> _menu) {
    this.menu = _menu;
  }

  List<Drink> addDrink(Drink _drink) {
    List<Drink> _temp = List.empty(growable: true);
    _temp.addAll(this.menu);
    _temp.add(_drink);
    this.menu = _temp;
    return this.menu;
  }

  List<Drink> addAllDrinks(List<Drink> _menu) {
    _menu.forEach((element) {
      this.addDrink(element);
    });
    return this.menu;
  }

  Drink removeDrink(Drink _drink) {
    List<Drink> _temp = List.from(this.menu, growable: true);
    _temp.remove(_drink);
    this.menu = _temp;
    return _drink;
  }

  void swap(int oldIndex, int newIndex) {
    List<Drink> _temp = List.from(this.menu, growable: true);
    final Drink d = _temp.removeAt(oldIndex);
    _temp.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, d);
    this.menu = _temp;
  }

  void clearAmount() {
    this.menu.forEach((element) => element.amount = 0);
  }

  void clear() {
    this.menu = List.empty(growable: true);
  }

  void setName(String _name) {
    this.name = _name;
  }

  void setColor(int _color) {
    this.color = _color;
  }

  void saveToHistory() {
    //history ??= Map<DateTime, List<Drink>>();

    history[DateTime.now()] = this.menu.where((Drink d) => d.amount > 0).toList();
  }

  void deleteHistory() {
    this.history.clear();
  }

  void removeFromHistroy(DateTime dt) {
    this.history.remove(int);
  }

  factory Bar.impuls() {
    return Bar(name: 'Jeugdhuis Impuls', menu: [
      Drink(name: 'Stella', price: 1.5, key: UniqueKey()),
      Drink(name: 'Duvel', price: 2, key: UniqueKey()),
      Drink(name: 'Chouffe', price: 2, key: UniqueKey()),
      Drink(name: 'Westmalle dubbel', price: 2.2, key: UniqueKey()),
      Drink(name: 'Westmalle trippel', price: 2.2, key: UniqueKey()),
      Drink(name: 'Omer', price: 2.0, key: UniqueKey()),
      Drink(name: 'Fles wijn rood', price: 9.0, key: UniqueKey()),
      Drink(name: 'Fles wijn wit', price: 9.0, key: UniqueKey()),
      Drink(name: 'Ice Tea', price: 1.5, key: UniqueKey()),
      Drink(name: 'Ice Tea pis', price: 1.5, key: UniqueKey()),
      Drink(name: 'Water plat', price: 1.5, key: UniqueKey()),
      Drink(name: 'Water bruis', price: 1.5, key: UniqueKey()),
      Drink(name: 'Cola', price: 1.5, key: UniqueKey()),
    ]);
  }

  factory Bar.sport() => Bar(name: 'Sportlokaal', menu: [
        Drink(name: 'Stella', price: 1.7, key: UniqueKey()),
        Drink(name: 'Duvel', price: 2.7, key: UniqueKey()),
        Drink(name: 'Chouffe', price: 3, key: UniqueKey()),
        Drink(name: 'Westmalle trippel', price: 3, key: UniqueKey()),
      ]);
}

/*
    // String str = '{"name":"${this.name}","menu":[';
    // for (Drink drink in this.menu) {
    //   str += '["${drink.name}",${drink.price}]';
    // }
    for (int i = 0; i < this.menu.length; i++) {
      Drink drink = this.menu[i];
      str += '["${drink.name}",${drink.price}]';
      if (i < this.menu.length - 1) {
        str += ',';
      }
    }
    str += ']}';
    return encoded ? base64.encode(lzma.encode(utf8.encode(str))) : str;
*/
