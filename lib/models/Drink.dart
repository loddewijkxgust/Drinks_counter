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
  
  Drink({
    this.name = 'Empty',
    this.price = 0.0,
    this.amount = 0
  });
  
  int plus() {
    if (this.amount < 1000) {
      this.amount++;
    }
    return this.amount;
  }

  int min() {
    if (this.amount > 0) {
      this.amount--;
    }
    return this.amount;
  }
}