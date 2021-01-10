import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/cards/share.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/store/businesshome.dart';
import 'package:flutter/rendering.dart';
import 'package:e_commerce/customer/orderdetail.dart';

class Complete33 extends StatelessWidget {
  StoreInfo storeInfo;
  UserInfo userInfo;
  Complete33({this.userInfo,this.storeInfo});
  @override
  Widget build(BuildContext context) {
    var _width=MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          shareCard(context, storeInfo),
          Container(
            width: _width*0.45,
            height: _height*0.03,
            // color: Colors.red,
            margin: EdgeInsets.fromLTRB(_width*0.05,0,0,0),
            child: AutoSizeText("Store 33% Completed",style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal,width: 1),
            ),
            margin: EdgeInsets.all(_width*0.05),
            padding: EdgeInsets.all(_width*0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: _height*0.01,),
                    Container(
                      height: _height*0.06,
                      width: _width*0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo[900],
                      ),
                      child: Icon(Icons.check,color: Colors.white,),
                    ),
                    getdot(context),getdot(context),getdot(context),getdot(context),getdot(context),
                    Container(
                      height: _height*0.06,
                      width: _width*0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrangeAccent.withOpacity(.3),
                        border: Border.all(color: Colors.indigo[900],width: 2),
                      ),
                      child: Center(child: AutoSizeText("2",style: TextStyle(
                          color: Colors.indigo[900],
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                        maxLines: 1,
                      )
                      ),
                    ),
                    getdot(context),getdot(context),getdot(context),getdot(context),getdot(context),
                    Container(
                      height: _height*0.06,
                      width: _width*0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey,width: 2),
                      ),
                      child: Center(child: AutoSizeText("3",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                        maxLines: 1,
                      )
                      ),
                    ),
                  ],
                ),
                SizedBox(width: _width*0.05,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: _height*0.01,),
                    Container(
                      height: _height*0.03,
                      width: _width*0.5,
                      child: AutoSizeText("Create Online Store",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                        height: _height*0.06,
                        width: _width*0.6,
                        child: AutoSizeText("Congratulations on opening your new online store !",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        )
                    ),
                    SizedBox(height: _height*0.01,),
                    Container(
                      // color: Colors.red,
                      height: _height*0.03,
                      width: _width*0.3,
                      child: AutoSizeText("Visit store",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.indigo[900],
                      ),
                      maxLines: 1,
                      ),
                    ),
                    SizedBox(height: _height*0.03,),
                    Container(
                      height: _height*0.03,
                      width: _width*0.3,
                      // color: Colors.red,
                      child: AutoSizeText("Welcome",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      height: _height*0.08,
                        width: _width*0.63,
                        child: AutoSizeText("Create your first product by adding the product name and image.",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        maxLines: 3,
                        )
                    ),
                    SizedBox(height: _height*0.01,),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context, CupertinoPageRoute(builder: (context) => BusinessHome(storeInfo: storeInfo,userInfo: userInfo,))
                        );
                      },
                      child: Container(
                        width: _width*0.32,
                        height: _height*0.05,
                        decoration: BoxDecoration(
                            color: Colors.indigo[900],
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Center(
                          child: Text(
                            "Home",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _height*0.03,),
                    Container(
                      height: _height*0.03,
                      width: _width*0.6,
                      // color: Colors.red,
                      child: AutoSizeText("Share on WhatsApp",style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
