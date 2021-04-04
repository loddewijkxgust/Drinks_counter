import 'package:drinkscounter/models/Bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


// ignore: must_be_immutable
class AddBarForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();
  bool isNew;
  
  AddBarForm(this.isNew);
  
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
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    
                    if (this.isNew) {
                      switch (this.name.toLowerCase()) {
                        case '**impuls':
                          bar = Bar.impuls();
                          break;
                        case '**sport':
                          bar = Bar.sport();
                          break;
                        default:
                          bar = new Bar(name: this.name);
                          
                      }
                      bars.add(bar);
                      vals.put('last', bars.keyAt(bars.length-1));
                      bars.get(vals.get('last'))?.save();
                    } else {
                      bar.setName(this.name);
                      bar.save();
                    }
                  
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${this.name}'))
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

