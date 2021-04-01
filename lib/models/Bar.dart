import 'dart:convert';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/cupertino.dart';
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
  Map<DateTime, List<Drink>>? history = Map<DateTime, List<Drink>>();

  Bar({
    this.name = 'Empty',
    this.menu = const [],
  });

  Bar.fromString({
    required String string,
    encoded = false,
    this.name = 'Empty',
    this.menu = const [],
  }) {
    print('gestart');
    string = encoded ? utf8.decode(lzma.decode(base64.decode(string))) : string;
    print('*******************************');
    Map<String, dynamic> json = jsonDecode(string);
    print('-------------------------------');

    print(string);
    this.name = json['name'];
    List<dynamic> _menu = json['menu'];

    _menu.forEach((item) {
      this.addDrink(new Drink(
        name: item[0],
        price: double.parse(item[1].toString()),
        key: UniqueKey(),
      ));
    });
  }

  String toString({encoded = false}) {
    String str = '{"name":"${this.name}","menu":[';
    for (int i = 0; i < this.menu.length; i++) {
      Drink drink = this.menu[i];
      str += '["${drink.name}",${drink.price}]';
      if (i < this.menu.length - 1) {
        str += ',';
      }
    }
    str += ']}';
    return encoded ? base64.encode(lzma.encode(utf8.encode(str))) : str;
  }

  List<Drink> setMenu(List<Drink> _menu) {
    this.menu = _menu;
    return this.menu;
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

  static Bar empty() {
    return new Bar(name: 'Empty');
  }

  void setName(String _name) {
    this.name = _name;
  }

  void saveToHistory() {
    history ??= Map<DateTime, List<Drink>>();
    history?[DateTime.now()] = this.menu;
  }

  void deleteHistory() {
    this.history?.clear();
  }

  void removeFromHistroy(DateTime dt) {
    this.history?.remove(int);
  }
}
