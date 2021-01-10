import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/shop.dart';
import 'package:e_commerce/customer/store_customer_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/category.dart';

class ShopCard extends StatelessWidget {
  UserInfo userInfo;
  StoreInfo shopVar;
  ShopCard({this.shopVar,this.userInfo});
  @override
  Widget build(BuildContext context) {
    var _width= MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        debugPrint(this.shopVar.name);
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => Store(userInfo:userInfo , storeInfo:shopVar ,))
        );
      },
      child: Container(
        height: _height*0.35,
        width: _width*0.91,
        margin: EdgeInsets.fromLTRB(_width*0.05, _height*0.02, _width*0.04, _height*0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 3.0,
              spreadRadius: 0,
              offset: Offset(1.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)),
              child: Container(
                width: _width*0.91,
                height: _height*0.23,
                color: Colors.grey[100],
                child: shopVar.img!=""?Image(width: _width*0.91, image: NetworkImage(shopVar.img), fit: BoxFit.fill,):null,
              ),
            ),
            SizedBox(height: _height*0.02,),
            Container(
              width: _width*0.91,
              height: _height*0.08,
              // color: Colors.grey[100],
              padding: EdgeInsets.fromLTRB(_width*0.03, 0,_width*0.03, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: _height*0.05,
                        width: _width*0.5,
                        child: AutoSizeText(
                          shopVar.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: _width*0.5,
                        height: _height*0.03,
                        child: AutoSizeText(
                          'category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: _width*0.1,),
                  Container(
                      height: _height*0.05,
                      width: _width*0.25,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              MdiIcons.starBox,
                              color: Colors.redAccent[700],
                              size: 22,
                            ),
                            width: _width*0.08,
                          ),
                          Container(
                            width: _width*0.14,
                            child: AutoSizeText(
                              shopVar.rating.toString() + " / 5.0",
                              style: TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}