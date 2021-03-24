import 'package:drinkscounter/models/Bar.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Gustl/Desktop/Code/Apps/Flutter/drinks_counter3/drinks_counter/lib/Old/CustomNotification.dart';
import 'package:hive/hive.dart';


// ignore: must_be_immutable
class AddBarForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
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
              validator: (value) {
                if (value == null) {
                  return 'Invalid input';
                } else if (value.isEmpty) {
                  return 'Enter name';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Bar name',
              ),
              onSaved: (value) {
                this.name = value ?? 'Leeg';
              },
            ),
          
            
            Align(
              alignment: Alignment.centerRight,
            
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    bar = new Bar(name: this.name);
                    bars.add(bar);
                    vals.put('last', bars.keyAt(bars.length-1));
                    print(bars.keys);
                    //CustomNotification(notification: Notifications.update)..dispatch(context);
                  
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${this.name}'))
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            )
          
            // Add TextFormFields and ElevatedButton here.
          ]))
      ],
    );
  }
}
