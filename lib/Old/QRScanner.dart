
import 'package:drinkscounter/models/Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  var bars = Hive.box<Bar>('bars');
  var vals = Hive.box<dynamic>('values');
  
  String qrString = '';
  
  @override
  void initState() {
    
    super.initState();
  }
  
  

  
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      
      children: [
        TextButton(
          child: Text('Scan'),
          onPressed: () {
            scan();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
  
  void scan() async {
    this.qrString = await FlutterBarcodeScanner.scanBarcode('#000000', 'Cancel', true, ScanMode.QR);
      print(this.qrString);
      try {
        Bar bar = Bar.fromString(string: this.qrString);
        bars.add(bar);
        vals.put('last', bars.keyAt(bars.length-1));
      } catch (e) {
        print('Fout: $e}');
      }
      
    setState(() {});
  }

  @override
  void dispose() {
    bars.close();
    vals.close();
    super.dispose();
  }
}
