// sayant

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QrGenerate extends StatefulWidget {
  @override
  _QrGenerateState createState() => _QrGenerateState();
}

var path;

class _QrGenerateState extends State<QrGenerate> {
  String _text = "google.com";
  var k;
  var clicked = false;
  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      return a.buffer.asUint8List();
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    toQrImageData(_text).then((value) {
      setState(() {
        k = value;
        clicked = true;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    Future<void> savePdf() async {
      final doc = pw.Document();
      doc.addPage(
          pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) => pw.Container(
              child: pw.Container(
                color: PdfColor.fromHex("ffffff"),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left:85,bottom: 25),
                      child:pw.Image(PdfImage.file(doc.document, bytes: k))),
                      pw.Padding(
                      padding: pw.EdgeInsets.only(left:85,bottom: 15),
                      child:pw.Text(
                        "Shop Name",
                        style: pw.TextStyle(
                          fontSize: 40,
                        ),
                      )),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 85),
                        child: pw.Text(
                          "+91987654321",
                          style: pw.TextStyle(
                              fontSize: 25,
                              fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                      ),
                    ]
                ),
              ))
          )
      );
      final output = await getExternalStorageDirectories(type: StorageDirectory.downloads);
      print(output[0].path);
      path = "${output[0].path}/example.pdf";
      final file = File("${output[0].path}/example.pdf");
      file.writeAsBytes(doc.save());
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: (){},
            icon: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(
                MdiIcons.close,
                size: _width*.08,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            "QR code",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Roboto-Medium",
                fontSize: 18
            ),
          ),
        ),
      body: Container(
        height: _height,
        width: _width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: _height*.15,bottom: _height*.06),
              child: clicked?Image.memory(k):Container()
            ),
            Container(
              alignment: Alignment.center,
              width: _width,
              child: AutoSizeText(
                  "Shop Name",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Roboto-Medium"
                ),
                  presetFontSizes: [25, 18],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: _height*.01,bottom: _height*.07),
              child: Container(
                alignment: Alignment.center,
                width: _width,
                child: AutoSizeText(
                  "Shop Address",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Roboto-Light",
                    fontWeight: FontWeight.w500
                  ),
                  presetFontSizes: [18, 10],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: (){
                savePdf();
              },
              child: Container(
                height: _height*.07,
                width: _width*.8,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(30, 132, 127, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                    child: Text(
                        "Save as Pdf",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Roboto-Medium",
                        color: Colors.white
                      ),
                    ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
