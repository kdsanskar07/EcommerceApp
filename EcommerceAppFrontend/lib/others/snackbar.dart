import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showFlushBar(bool isSuccess,String msg,BuildContext context) {
  var _height = MediaQuery.of(context).size.height;
  var _width = MediaQuery.of(context).size.width;
  Flushbar(
    borderRadius: 8,
    icon: isSuccess?Icon(Icons.check,color: Colors.greenAccent[700]):Icon(Icons.cancel,color: Colors.redAccent[700]),
    message: msg,
    margin: EdgeInsets.fromLTRB(_width*0.04, 0, _width*0.04, _height*0.02),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.black,
  )..show(context);
}