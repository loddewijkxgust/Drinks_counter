import 'package:drinkscounter/models/Drink.dart';
import 'package:hive/hive.dart';
part 'hive/Bar.g.dart';

@HiveType(typeId: 2)
class Bar extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Drink> menu = List<Drink>.empty(growable: true);
//  HiveList menu = List<drink>.empty(growable: true);
  
  Bar({
    this.name = 'Empty',
  });
  
  List<Drink> setMenu(List<Drink> _menu) {
    this.menu = _menu;
    return this.menu;
  }
  @HiveField(3)
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
}