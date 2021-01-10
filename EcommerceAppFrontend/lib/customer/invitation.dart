// anurag

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Future<void> share() async {
    await FlutterShare.share(
        title: 'this is the new title',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
        linkUrl: 'https://www.geeksforgeeks.org/',
        chooserTitle: 'Title');
  }

  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
          title: Text(
            'Invite',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin:EdgeInsets.fromLTRB(_width*0.05, _height*0.02, _width*0.05, 0),
            height: _height*.25,
            width: _width*0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                color: Colors.lightBlueAccent,
                width: _width*0.91,
                height: _height*0.23,
                child: Image(
                  image: AssetImage('assets/images/First.png'),
                  height: _height * .36,
                  width: _width,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: _height * .12,
            width: _width * .89,
            margin:EdgeInsets.fromLTRB(0, _height*0.02, _width*0.05, 0),
            // color: Colors.red,
            child: Image(
               fit: BoxFit.fill,
              image: AssetImage('assets/images/Share.jpg'),
              width: _width,
            ),
          ),
          SizedBox(height: _height*0.02,),
          Container(
            child: AutoSizeText(
              'Why Should You Choose Us',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
              maxLines: 1,
            ),
          ),
          SizedBox(height: _height*0.03,),
          Row(children: <Widget>[
            SizedBox(
              width: _width * .071,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 24,
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.home, color: Colors.white),
                      color: Colors.black,
                      iconSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.012,
                  ),
                  Container(
                    child: AutoSizeText(
                      'Trusted',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.004,
                  ),
                  Container(
                    child: Container(
                      child: AutoSizeText(
                        'Nearby Stores',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: _width * .048,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 24,
                    child: IconButton(
                      onPressed: (){

                      },
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      iconSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.012,
                  ),
                  Container(
                    child: AutoSizeText(
                      'Schedule',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.004,
                  ),
                  Container(
                    child: AutoSizeText(
                      'Delivery',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: _width * 0.055,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 24,
                    child: IconButton(
                      onPressed: (){

                      },
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                      iconSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.012,
                  ),
                  Container(
                    child: AutoSizeText(
                      '24*7 Order',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.004,
                  ),
                  Container(
                    child: AutoSizeText(
                      'Placements',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: _width * 0.07,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 24,
                    child: IconButton(
                      onPressed: (){

                      },
                      icon: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      ),
                      iconSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.012,
                  ),
                  Container(
                    child: AutoSizeText(
                      'Pay On',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.004,
                  ),
                  Container(
                    child: AutoSizeText(
                      'Delivery',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
          ]),
          SizedBox(height: _height*0.2,),
          InkWell(
            child: Container(
              height: _height * 0.07,
              margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.teal,
              ),
              child: Center(
                child: Container(
                  child: AutoSizeText(
                    'Share',
                    style: TextStyle(
                      //backgroundColor: Colors.teal,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            onTap: () {
              share();
            },
          ),

        ],
      ),
    );
  }
}
