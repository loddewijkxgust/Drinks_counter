import 'package:drinkscounter/models/Bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatefulWidget {
  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
  Bar bar = Bar.empty();
  
  String qrString = '';
  
  @override
  void initState() {
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    bar = bars.get(vals.get('last')) ?? bar;
    double width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      //title: Text(JSONParse.barToStr(bar)),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(50),
      children: [
        Center(
          child: Container(
            color: Colors.white,
            width: width*.9,
            child: QrImage(
              data: bar.toString(encoded: true),
            //size: width*.85,
            ),
          ),
        ),
      ],
    );
  }

//  @override
//  void dispose() {
//    bars.close();
//    vals.close();
//    super.dispose();
//  }
}
