/**
SpeedDialChild(
labelBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
child: Icon(Icons.add),
label: 'Add drink',
onTap: () async {

AddDrinkForm form = new AddDrinkForm();
await showDialog(
context: context,
builder: (BuildContext context) {
return form;
},
barrierDismissible: false,
);
setState(() {
bar.addDrink(new Drink(name: form.name, price: form.price));
bar.save();
});
},
backgroundColor: Theme.of(context).primaryColor,
),*/
