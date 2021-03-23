import 'package:drinkscounter/Notifications/CustomNotification.dart';
import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/models/Drink.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class AddDrinkForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = -1;
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();
  
  @override
  Widget build(BuildContext context) {
    bar = bars.get(vals.get('last')) ?? bar;
    // Build a Form widget using the _formKey created above.
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      children: [
        Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null) {
                  return 'Invalid input';
                } else if (value.isEmpty) {
                  return 'Please enter name';
                }
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
                if (value == null ) {
                  return 'Invalid input';
                } else if (value.isEmpty) {
                  return 'Please enter price';
                }
                try {
                  double.parse(value);
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
                this.price = double.parse(value ?? '0');
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    
                    bar.addDrink(new Drink(name: this.name, price: this.price));
                    bar.save();
                    CustomNotification(notification: Notifications.update)..dispatch(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${this.name}  ::  ${this.price}'))
                    );
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

