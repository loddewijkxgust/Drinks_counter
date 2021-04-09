import 'package:drinkscounter/models/Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive/hive.dart';


// class AddBarForm extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   late String name = '';
//   var bars = Hive.box<Bar>('bars');
//   var vals = Hive.box<dynamic>('values');
//   Bar bar = Bar.empty();
//   bool isNew;
  
//   AddBarForm(this.isNew);
  
//   @override
//   Widget build(BuildContext context) {
//     bar = bars.get(vals.get('last')) ?? bar;
//     return AddBarForm(formKey: _formKey, name: name, isNew: isNew, bars: bars, bar: bar, vals: vals);
//   }
// }


// ignore: must_be_immutable
class AddBarForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool isNew;
  final Box<Bar> bars;
  final Box vals;
  String name;
  Bar bar;
  int? color;
  
  AddBarForm({
    Key? key,
    this.name = '',
    this.isNew = true,
    required this.bars,
    required this.bar,
    required this.vals,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      children: [
        Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              maxLength: 16,
              initialValue: this.isNew ? '' : bar.name,
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

            Container(
              child: MaterialColorPicker(
                onColorChange: (Color color) => this.color = color.value,
                onMainColorChange: (colorSwatch) => print('onMainColorChange: $colorSwatch'),
                selectedColor: this.isNew ? Colors.red : Color(bar.color),
              ),
              height: 250,
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
                        case '****':
                          bar = Bar.impuls();
                          break;
                        case '**sport':
                          bar = Bar.sport();
                          break;
                        default:
                          bar = new Bar(name: this.name);
                      }
                      bar.setColor(this.color ?? bar.color);
                      bars.add(bar);
                      vals.put('last', bars.keyAt(bars.length-1));
                      bars.get(vals.get('last'))?.save();


                    } else {
                      bar.setName(this.name);
                      bar.setColor(this.color ?? bar.color);
                      bar.save();
                    }
                  
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

