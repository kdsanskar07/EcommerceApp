import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

Widget shareCard(BuildContext context,StoreInfo storeInfo) {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }
  var _height=MediaQuery.of(context).size.height;
  var _width=MediaQuery.of(context).size.width;
  return Stack(
    children: <Widget>[
      Container(
        height: _height*0.33,
        color: Colors.white,
      ),
      Container(
        height: _height*0.25,
        color: Colors.teal,
      ),
      Container(
        margin: EdgeInsets.fromLTRB(_width*0.04, _height*0.06, _width*0.025, 0),
        width: _width*0.7,
        height: _height*0.034,
        child: AutoSizeText(
          storeInfo.name,style: TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
          maxLines: 1,
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(_width*0.04, _height*0.13, _width*0.04,0),
        height: _height*0.18,
        padding: EdgeInsets.all(_width*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: _height*0.027,
              width: _width*0.5,
              child: AutoSizeText(
                "Share link with customers",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: _width*0.025,
            ),
            Container(
                width: _width*0.9,
                height: _height*0.05,
                child: AutoSizeText(
                  "Your customers can visit your online store and place orders from this link.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 2,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width:_width*0.5,
                  height: _height*0.023,
                  child: AutoSizeText(
                    "sharemystore/0000-000"+storeInfo.storeId,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: _width*0.05,
                ),
                InkWell(
                  onTap: (){
                    debugPrint("share with customers");
                    share();
                  },
                  child: Container(
                    width: _width*0.3,
                    height: _height*0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: Colors.teal,width: 2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: _width*0.1,
                          child: Icon(Icons.share,color: Colors.teal,),
                        ),
                        Container(
                          width: _width*0.18,
                          height: _height*0.06,
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Share",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.teal
                            ),
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.teal,width: 1),
        ),
      )
    ],
  );
}