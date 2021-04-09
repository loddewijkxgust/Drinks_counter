// SpeedDial(
//               overlayOpacity: 0.4,
//               icon: Icons.menu,
//               backgroundColor: Theme.of(context).accentColor,
//               //backgroundColor: Theme.of(context).primaryColor,
//               children: [
//                 SpeedDialChild(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   child: Icon(Icons.add),
//                   labelWidget: Text(
//                     'Add drink',
//                     style: TextStyle(
//                       fontSize: Values.fontSizeSmall,
//                       )),
//                   onTap: () async {
//                     await showDialog(
//                       context: context,
//                       builder: (BuildContext context) => AddDrinkForm(),
//                     );
//                     setState(() {});
//                   },
//                   //backgroundColor: Theme.of(context).colorScheme.primary,
//                 ),

//                 SpeedDialChild(
//                   backgroundColor: Theme.of(context).primaryColor,
//                     child: Icon(Icons.qr_code_rounded),
//                     labelWidget: Text('Share bar', style: TextStyle(
//                       fontSize: Values.fontSizeSmall,
//                       )),
//                     onTap: () async {
//                       await showDialog(
//                         context: context,
//                         builder: (context) => QRGenerator(),
//                       );
//                       setState(() {});
//                     }
//                 ),

//                 //if (!kReleaseMode)
//                 SpeedDialChild(
//                   child: Icon(Icons.local_drink),
//                   onTap: () {
//                     setState(() {
//                       bar.addDrink(new Drink(
//                           name: 'Duvel',
//                           price: 2.7,
//                           amount: 3,
//                           key: UniqueKey()));
//                       bar.addDrink(new Drink(
//                           name: 'Stella',
//                           price: 1.7,
//                           amount: 8,
//                           key: UniqueKey()));
//                       bar.addDrink(new Drink(
//                           name: 'Cara',
//                           price: 0.2,
//                           amount: 283,
//                           key: UniqueKey()));
//                       bar.save();
//                     });
//                   },
//                 ),

//                 //if (!kReleaseMode)
//                 SpeedDialChild(
//                   child: Icon(Icons.bug_report),
//                   onTap: () async {
//                     PackageInfo packageInfo =
//                         await PackageInfo.fromPlatform();

//                     await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SimpleDialog(
//                             titleTextStyle: TextStyle(fontSize: 30),
//                             children: [
//                               Text('Ad loaded: pass'),
//                               Text('Release mode: $kReleaseMode'),
//                               Text('AppName: ${packageInfo.appName}'),
//                               Text('Package name: ${packageInfo.packageName}'),
//                               Text('Version: ${packageInfo.version}'),
//                               Text('Build Number: ${packageInfo.buildNumber}'),
//                               Text('Error: $err1'),
//                               Text('Error: $err'),
//                             ],
//                           );
//                         });
//                   },
//                 ),

//                 SpeedDialChild(
//                     child: Icon(Icons.refresh),
//                     onTap: () => setState(() {}),
//                     ),

//                 SpeedDialChild(
//                   child: Icon(Icons.color_lens_outlined),
//                   onTap: () async {

//                     await showDialog(
//                       context: context,
//                       builder: (context) {
//                         return Dialog(
//                           child: MaterialColorPicker(),
//                         );
//                       }
//                     );
//                   }
//                 ),
//               ],
//             ),