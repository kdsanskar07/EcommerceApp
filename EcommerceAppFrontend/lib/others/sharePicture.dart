// anurag

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:share/share.dart';

class Temari extends StatefulWidget {
  @override
  _TemariState createState() => _TemariState();
}

class _TemariState extends State<Temari> {
  String text = 'anurag';
  String subject = 'yadav';
  List<String> imagePaths = [];
  BuildContext scaffoldContext;

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: new Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return new Center(
          child: InkWell(
            child: Container(
              height: _height * 0.07,
              margin: EdgeInsets.symmetric(horizontal: _width * 0.09),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.orange[900],
              ),
              child: Center(
                child: Container(
                  child: AutoSizeText(
                    'Share',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            onTap: () {
              //createSnackBar("Message is deleted", false);
               _onShare(context);
            },
          ),
        );
      }),
    );
  }

  void createSnackBar(String message, bool flag) {
    final snackBar = new SnackBar(
      content: Container(
          child: Row(
        children: <Widget>[
          Container(
            child: new AutoSizeText(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.45,
            //color: Colors.red,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
          ),
          IconButton(
            onPressed: (){},
            icon: flag
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
            iconSize: 34,
            color: Colors.white,
          ),
        ],
      )),
      backgroundColor: Colors.black,
    );
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}
