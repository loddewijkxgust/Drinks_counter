//import 'dart:convert';
//
//import 'package:drinkscounter/models/Bar.dart';
//import 'package:drinkscounter/models/Drink.dart';
//import 'package:lzma/lzma.dart';
//
//class JSONParse{
//  static String barToStr(Bar bar, {bool encoded = false}) {
//    //return bar.menu.fold('{"name":"${bar.name}","menu":[', (String str, Drink drink) => str + '["${drink.name}",${drink.price}],') + ']}';
//
//    String str = '{"name":"${bar.name}","menu":[';
//    for (int i = 0; i < bar.menu.length; i++) {
//      Drink drink = bar.menu[i];
//      str += '["${drink.name}",${drink.price}]';
//      if (i < bar.menu.length-1) {
//        str += ',';
//      }
//    }
//    str += ']}';
//    return encoded ? base64.encode(lzma.encode(utf8.encode(str))) : str;
//  }
//
//
//  static Bar strToBar(String str, {bool encoded = false})  {
//    str = encoded ? utf8.decode(lzma.decode(base64.decode(str))) : str;
//    Map<String, dynamic> json = jsonDecode(str);
//    Bar bar = new Bar(name: json['name']);
//
//    List<dynamic> menu = json['menu'];
//
//    menu.forEach((item) {
//      bar.addDrink(new Drink(
//        name: item[0],
//        price: double.parse(item[1].toString()),
//      ));
//    });
//    return bar;
//  }
//}