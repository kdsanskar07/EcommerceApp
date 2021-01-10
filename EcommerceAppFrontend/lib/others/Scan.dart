import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


class CodeScan extends StatefulWidget {
  @override
  _CodeScanState createState() => _CodeScanState();
}
class _CodeScanState extends State<CodeScan> {
  String result = "Hey! There";
  var back=0;
  Future _scanQR() async {
    try {
      back=1;
      String qrScanner = (await BarcodeScanner.scan()) as String;
      setState(() {
        result = qrScanner;
      });
    } on PlatformException catch (execption) {
      if (execption.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera Permission Denied";
        });
      }
      else {
        setState(() {
          result = "Unknown-Error";
        });
      }
    } on FormatException {
      setState(() {
        result = "You Pressed The Cancel Button before Starting";
      });
    } catch (ex) {
      result = "Unknown-error";
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("QR Scanner"),
        ),
        body: Center(
          child: Text(
            result,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: _scanQR,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    back==0?_scanQR():Future.delayed(Duration.zero, () async {
      Navigator.pop(context);
    });
    return Container();
  }
}