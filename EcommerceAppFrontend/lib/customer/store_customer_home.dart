import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/customer/customerShopProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/category.dart';


class category {
  String name;
  int noOfProducts;
  category({this.name, this.noOfProducts});
}

class Store extends StatefulWidget {
  UserInfo userInfo;
  StoreInfo storeInfo;

  Store({this.userInfo,this.storeInfo});
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  bool checkBookmark = false;
  bool isBookmark = false;
  bool getCategoryList = false;

  List<CategoryInfo> categoryData = [];

  Future<void> checkBookmarkStore() async{
    Requests request = new Requests(
        isHeader: true,
        bodyData: {
          'storeid': widget.storeInfo.storeId,
        },
        context: context,
        url: 'http://10.0.2.2:3000/bookmark/check'
    );
    var response = await request.postRequest();
    print(response['result'].toString());
    setState(() {
      if(response['result'] == true){
        setState(() {
          isBookmark = true;
        });
      }
      else{
        setState(() {
          isBookmark = false;
        });
      }
    });

  }

  Future<void> getCategoryListInfo() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/categorystore/getcategorylist'
    );
    var response = await request.getRequest();
    print("value: "+response['data'].toString());
    print(response['data']['categoryList'].length);
    for(var i=0;i<response['data']['categoryList'].length;i++){
      CategoryInfo temp = CategoryInfo(
        imgPath: categoryInfoList[response['data']['categoryList'][i]].imgPath,
        name: categoryInfoList[response['data']['categoryList'][i]].name,
        noOfProduct: response['data']['noOfProductList'][i],
        isPresentInStore: true,
      );
      categoryData.add(temp);
    }
  }

  @override
  void initState() {
    super.initState();
    checkBookmarkStore().then((value) => {
      setState(() {
        checkBookmark=true;
      }),
    });;
    getCategoryListInfo().then((value) => {
      setState(() {
        getCategoryList=true;
      }),
    });
  }


  Future<void> addBookmarkStore() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: {
          'storeid': widget.storeInfo.storeId,
        },
        context: context,
        url: 'http://10.0.2.2:3000/bookmark/create'
    );
    var response = await request.postRequest();
    print(response['data'].toString());
    setState(() {
      isBookmark = true;
    });
  }

  Future<void> deleteBookmarkStore() async{
    Requests request = new Requests(
        isHeader: true,
        bodyData: {
          'storeid': widget.storeInfo.storeId,
        },
        context: context,
        url: 'http://10.0.2.2:3000/bookmark/delete'
    );
    var response = await request.postRequest();
    print(response['data'].toString());
    setState(() {
      isBookmark = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: !getCategoryList && !checkBookmark?Text('Loading'):Column(
        children: <Widget>[
          Container(height: _height*0.03,color: Colors.teal,),
          Stack(
            children: <Widget>[
              Container(
                height: _height*0.26,
                width: _width,
                color: Colors.grey[200],
                child: widget.storeInfo.img!=""?Image(width: _width*0.91, image: NetworkImage(widget.storeInfo.img), fit: BoxFit.fill):null,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, _height*0.15, 0, 0),
                height: _height*0.08,
                width: _width*0.6,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(_width*0.04, _height*0.013, _width*0.04, _height*0.013),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                  ),
                  child: AutoSizeText(
                    widget.storeInfo.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                height: _height*0.05,
                width: _width*0.1,
                margin: EdgeInsets.fromLTRB(_width*0.87, _height*0.015, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                    child: Center(child: isBookmark==true?Icon(Icons.bookmark,color: Colors.teal,):Icon(Icons.bookmark_border,color: Colors.teal)),
                  onTap: (){
                      isBookmark?deleteBookmarkStore():addBookmarkStore();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(_width*0.05, _height*0.03, 0, 0),
                child: Icon(Icons.arrow_back,color: Colors.white,),
              )
            ],
          ),
          Container(height: 2,color: Colors.teal,),
          Container(
            height: _height*0.7,
            child: ListView(
              children: <Widget>[
                Container(
                  width: _width*0.3,
                  height: _height*0.035,
                  margin: EdgeInsets.fromLTRB(_width*0.04, 0, 0, 0),
                  child: AutoSizeText(
                    "Select category",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  height: categoryData.length*_height*0.133,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context, CupertinoPageRoute(builder: (context) => CustomerShopProducts(categoryListIndex: widget.storeInfo.categoryList[index],))
                            );
                          },
                          child: CategoryCard(
                            data: categoryData[index],
                          ),
                        );
                      },
                      itemCount: categoryData.length
                  ),
                ),
                Container(
                  width: _width,
                  height: _height*0.15,
                  padding: EdgeInsets.fromLTRB(_width*0.02,_height*0.02,_width*0.02,_height*0.02),
                  margin: EdgeInsets.fromLTRB(_width*0.025,_height*0.02,_width*0.025,0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black26,
                          offset: Offset(0,1),
                          spreadRadius: 0,
                        ),
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _width*0.1,
                        color: Colors.white,
                        child: Icon(Icons.location_on,size: 24,color: Colors.teal,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: _width*0.3,
                            child: AutoSizeText(
                              "Pickup Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: _width,
                  height: _height*0.15,
                  margin: EdgeInsets.fromLTRB(_width*0.025,_height*0.02,_width*0.025,0),
                  padding: EdgeInsets.fromLTRB(_width*0.02,_height*0.02,_width*0.02,_height*0.02),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black26,
                          offset: Offset(0,1),
                          spreadRadius: 0,
                        ),
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _width*0.1,
                        color: Colors.white,
                        child: Icon(Icons.access_time,size: 24,color: Colors.teal,),
                      ),
                      Container(
                        width: _width*0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: _width*0.3,
                              height: _height*0.03,
                              child: AutoSizeText(
                                "Store Timing",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: _height*0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  // color:Colors.blueGrey,
                                  height: _height*0.03,
                                  width: _width*0.12,
                                  child: AutoSizeText(
                                    'Day : ',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: _height*0.03,
                                  width: _width*0.03,
                                  child: AutoSizeText(
                                    'S',
                                    style: TextStyle(
                                      color: widget.storeInfo.isOpenOnSunday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.02,
                                ),
                                Container(
                                  width: _width*0.03,
                                  height: _height*0.03,
                                  child: AutoSizeText(
                                    'M',
                                    style: TextStyle(
                                      color: widget.storeInfo.isOpenOnMonday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.02,
                                ),
                                Container(
                                  height: _height*0.03,
                                  width: _width*0.03,
                                  child: AutoSizeText(
                                    'T',
                                    style: TextStyle(
                                      color: widget.storeInfo.isOpenOnTuesday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.02,
                                ),
                                Container(
                                  height: _height*0.03,
                                  width: _width*0.03,
                                  child: AutoSizeText(
                                    'W',
                                    style: TextStyle(
                                      color:widget.storeInfo.isOpenOnWednesday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.02,
                                ),
                                Container(
                                  height: _height*0.03,
                                  width: _width*0.03,
                                  child: AutoSizeText(
                                    'T',
                                    style: TextStyle(
                                      color: widget.storeInfo.isOpenOnThursday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.02,
                                ),
                                Container(
                                  height: _height*0.03,
                                  width: _width*0.03,
                                  child: AutoSizeText(
                                    'F',
                                    style: TextStyle(
                                      color: widget.storeInfo.isOpenOnFriday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.02,
                                ),
                                Container(
                                  height: _height*0.03,
                                  width: _width*0.03,
                                  child: AutoSizeText(
                                    'S',
                                    style: TextStyle(
                                      color: widget.storeInfo.isOpenOnSaturday==1?Colors.teal:Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: _height*0.01),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // color:Colors.grey,
                                    height: _height*0.03,
                                    width: _width*0.13,
                                    child: AutoSizeText(
                                      'Time : ',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: _height*0.03,
                                    width: _width*0.4,
                                    child: AutoSizeText(
                                      widget.storeInfo.openingTime+"-"+widget.storeInfo.closingTime,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await launch( "tel: +91 "+widget.storeInfo.mob);
                        debugPrint("call done");
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(_width*0.09, _height*0.03, 0, 0),
                        width: _width*0.35,
                        height: _height*0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.call,color: Colors.teal,),
                            Container(
                              margin:EdgeInsets.fromLTRB(_width*0.04,0, 0, 0),
                              child: Text("Call",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.teal
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(_width*0.1, _height*0.03, 0, 0),
                      width: _width*0.35,
                      height: _height*0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.share,color: Colors.teal,),
                          Container(
                            margin:EdgeInsets.fromLTRB(_width*0.04,0, 0, 0),
                            child: Text("Share",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.teal
                            ),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(height: _height*0.03,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  CategoryInfo data;
  CategoryCard({this.data});
  @override
  _CategoryCardState createState() => _CategoryCardState();
}
class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _heigth = MediaQuery.of(context).size.height;
    return Container(
      height: _heigth * 0.11,
      width: _width,
      margin: EdgeInsets.fromLTRB(
          _width * 0.03, _heigth * 0.022, _width * 0.03, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: Colors.teal.withOpacity(.5), width: 2)),
      child: Row(
        children: <Widget>[
          Container(
            width:_width*0.8,
            padding: EdgeInsets.fromLTRB(_width * 0.04,_heigth*0.02,0,_heigth*0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: _width*0.8,
                  height: _heigth*0.03,
                  child: AutoSizeText(
                    widget.data.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: _heigth*0.004,),
                Container(
                  width:_width*0.8,
                  height: _heigth*0.03,
                  child: AutoSizeText(
                    widget.data.noOfProduct.toString() + " Product listed",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: _width*0.1,
            child: Center(
              child: Icon(Icons.arrow_forward_ios,size: 18,),
            ),
          )
        ],
      ),
    );
  }
}