import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class AddDrinkForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = -1;
  final Box bars = Hive.box<Bar>('bars');
  final Box vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();
  
  @override
  Widget build(BuildContext context) {
    bar = bars.get(vals.get('last')) ?? bar;

    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      children: [
        Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              maxLength: 16,
              validator: (value) {
                if (value == null) return 'Invalid input';
                if (value.isEmpty) return 'Please enter name';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Drink name',
              ),
              onSaved: (value) {
                this.name = value ?? 'Leger';
              },
            ),
            
            TextFormField(
              validator: (value) {
                if (value == null ) return 'Invalid input';
                if (value.isEmpty) return 'Please enter price';
                try {
                  double.parse(value.replaceAll(',', '.'));
                  return null;
                } catch (e) {
                  return 'Not a valid number';
                }
              },
              decoration: InputDecoration(
                labelText: 'Price'
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              onSaved: (value) {
                this.price = double.parse(value?.replaceAll(',', '.') ?? '0');
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    if (this.name == '****') {
                      bar.addAllDrinks(Bar.impuls().menu);
                    } else {
                      bar.addDrink(new Drink(name: this.name, price: this.price, key: UniqueKey()));
                    }
                    bar.save();
                    
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            )
          ]))
      ],
    );
  }
}

