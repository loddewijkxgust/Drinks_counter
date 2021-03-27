import 'package:drinkscounter/models/Bar.dart';
import 'package:drinkscounter/widgets/AddBarForm.dart';
import 'package:drinkscounter/widgets/CustomPopupMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PopupMenu extends StatelessWidget {
  final Box bars = Hive.box<Bar>('bars');
  final Box vals = Hive.box<dynamic>('values');
  
  @override
  Widget build(BuildContext context) {
    Bar bar = bars.get(vals.get('last')) ?? Bar.empty();
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry>[
        
        CustomPopupMenuItem(
          icon: Icons.edit,
          text: Text('Edit name'),
          value: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AddBarForm(false),
            );
          },
        ),
        
        CustomPopupMenuItem(
          icon: Icons.delete,
          text: Text('Delete bar'),
          value: () {
            bar.clear();
            bar.save();
          },
        ),
        
        CustomPopupMenuItem(
          icon: Icons.clear,
          text: Text('Reset amount'),
          value: () {
            bar.clearAmount();
            bar.save();
          },
        ),
        
        CustomPopupMenuItem(
          icon: Icons.save,
          text: Text('Save'),
          value: () {
            bar.saveToHistory();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to history')));
            bar.save();
            print(bar.history?.length);
            bar.history?.forEach((key, value) {
              print('Key: $key ==> Value: $value');
            });
          },
        ),
        
        CustomPopupMenuItem(
          icon: Icons.history,
          text: Text('History'),
          value: () async {
            
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: LimitedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bar.history?.length,
                        itemBuilder: (context, index) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: bar.history?[index]?.length,
                            itemBuilder: (context, i) {
                              return Text(bar.history?[index]?[i].name ?? 'leeg');
                            }
                          );
                        }
                      ),
                      maxHeight: 300,
                    ),
                );
              });
          }
        )
        
      ],
      
      onSelected: (result) => (result as Function)(),
    );
  }
}