import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us",style: TextStyle(
          color: Colors.black87,
        ),),
        elevation: 1,
        leading: InkWell(onTap: (){
          Navigator.of(context).pop();
        },child: Icon(Icons.arrow_back,color: Colors.black87,)),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              margin:EdgeInsets.fromLTRB(_width*0.05, _height*0.05, _width*0.05, 0),
              height: _height*.22,
              width: _width*0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: Colors.green[300],
                  width: _width*0.91,
                  height: _height*0.4,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: _height*0.02,),
                      Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Your Local Online Store',
                          style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.fromLTRB(_width*0.02, _height*0.015, _width*0.02, 0),
                        child: AutoSizeText(
                          'Our motive is to bring your trusted local store to your smartphone. These General Provision Store'
                          ' have struggling to go online and digitize their services. With our app you can create the '
                              'your store and and sell your products online and for the buyer you can buy products from your '
                              'trusted local stores.',
                          style: TextStyle(fontSize: 14),
                          maxLines: 7 ,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
