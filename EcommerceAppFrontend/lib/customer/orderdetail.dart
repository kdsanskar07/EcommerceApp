import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:e_commerce/class/orderInfo.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:e_commerce/class/category.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderDetails extends StatefulWidget {
  OrderInfo data;
  OrderDetails({this.data});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoaded = false;
  var data;
  Future<void> getOrderProduct() async{
    var bodyData = {
      'id': widget.data.orderNo
    };
    Requests request = new Requests(
        bodyData: bodyData,
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/getOrderProduct'
    );
    var response = await request.postRequest();
    print(response);
    if(response['success'] == true){
      data = response['data'];
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderProduct().then((value) => {
      setState(() {
        isLoaded = true;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("ORDER DETAILS",style: TextStyle(
          color: Colors.black,
        ),),
        shape: Border(bottom: BorderSide(color: Colors.teal,width: 1)),
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            debugPrint("Back");
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: !isLoaded?Container(
        color: Colors.white,
        child: Center(child: SpinKitPouringHourglass(color: Colors.teal,)),
      ):ListView(
        children: <Widget>[
          SizedBox(height: _height*0.02,),
          Container(
            height: _height*0.048,
            width: _width,
            margin: EdgeInsets.fromLTRB(_width*0.07, _height*0.005, _width*0.47, _height*0.005),
            child: AutoSizeText(
              "Products List",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                letterSpacing: .8,
              ),
              maxLines: 1,
            ),
          ),
          CategoryList(data: data),
          Container(
            height: _height*0.048,
            width: _width,
            // color: Colors.grey,
            margin: EdgeInsets.fromLTRB(_width*0.05, _height*0.03, _width*0.5, _height*0.01),
            child: AutoSizeText(
              "Track Order",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                letterSpacing: .8,
              ),
              maxLines: 1,
            ),
          ),
          Container(
            // color: Colors.red,
            height: _height*0.036,
            width: _width,
            margin: EdgeInsets.fromLTRB(_width*0.06, 0,0,0),
            child: AutoSizeText(
              DateFormat.yMMMMd().format(DateTime.parse(widget.data.placeTime)),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width*0.06, 0, 0, _height*0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: _height*0.036,
                  width: _width*0.41,
                  child: AutoSizeText(
                    "Order ID: "+ widget.data.orderNo,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: _width * .11,
                ),
                Container(
                  height: _height*0.036,
                  width: _width*0.35,
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    "Total: "+ widget.data.total,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.04, _height*0.03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, _height*0.02,_width*0.05, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      geticon(context,widget.data.pickupTime!="null"?true:false),
                      getdot(context),
                      getdot(context),
                      getdot(context),
                      getdot(context),
                      geticon(context,widget.data.processedTime!="null"?true:false),
                      getdot(context),
                      getdot(context),
                      getdot(context),
                      getdot(context),
                      geticon(context,widget.data.paymentTime!="null"?true:false),
                      getdot(context),
                      getdot(context),
                      getdot(context),
                      getdot(context),
                      geticon(context,widget.data.placeTime!="null"?true:false),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, _height*0.01, 0, _height * 0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.shopping_basket,
                            size: _width*0.1,
                          ),
                          SizedBox(
                            width: _width*0.04,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: _width*.28,
                                    height: _height*0.025,
                                    child: AutoSizeText(
                                      "Ready to Pickup",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * .23,
                                  ),
                                  Container(
                                    width:_width*0.15,
                                    height: _height*0.025,
                                    child: widget.data.pickupTime=="null"?Container():AutoSizeText(
                                      DateFormat.jm().format(DateTime.parse(widget.data.pickupTime)),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                  width: _width*0.6,
                                  height: _height*0.024,
                                  child: AutoSizeText(
                                    "from "+widget.data.storeName,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, _height*0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: _width*0.1,
                          ),
                          SizedBox(
                            width: _width*0.04,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: _width*.28,
                                    height: _height*0.025,
                                    child: AutoSizeText(
                                      "Order Processed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * .23,
                                  ),
                                  Container(
                                    width:_width*0.15,
                                    height: _height*0.025,
                                    child: widget.data.processedTime=="null"?Container():AutoSizeText(
                                      DateFormat.jm().format(DateTime.parse(widget.data.processedTime)),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                  width: _width*0.6,
                                  height: _height*0.024,
                                  child: AutoSizeText(
                                    "We are preparing your order",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, _height*0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.account_balance_wallet,
                            size: _width*0.1,
                          ),
                          SizedBox(
                            width: _width*0.04,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: _width*.35,
                                    height: _height*0.03,
                                    child: AutoSizeText(
                                      "Payment Confirmed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * .16,
                                  ),
                                  Container(
                                    width:_width*0.15,
                                    height: _height*0.025,
                                    child: widget.data.paymentTime=="null"?Container():AutoSizeText(
                                      DateFormat.jm().format(DateTime.parse(widget.data.paymentTime)),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                  width: _width*0.6,
                                  height: _height*0.024,
                                  child: AutoSizeText(
                                    "Awaiting Confirmation...",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, _height*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.content_paste,
                            size: _width*0.1,
                          ),
                          SizedBox(
                            width: _width*0.04,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: _width*.28,
                                    height: _height*0.025,
                                    child: AutoSizeText(
                                      "Order Placed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * .23,
                                  ),
                                  Container(
                                    width:_width*0.15,
                                    height: _height*0.025,
                                    child: widget.data.placeTime=="null"?Container():AutoSizeText(
                                      DateFormat.jm().format(DateTime.parse(widget.data.placeTime)),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                  width: _width*0.6,
                                  height: _height*0.024,
                                  child: AutoSizeText(
                                    "We have recieved your order",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Center(
            child: Container(
              height: _height * .14,
              width: _width * .9,
              padding: EdgeInsets.fromLTRB(_width*0.03, _height*0.01, _width*0.03, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.business, size: _width*0.07, color: Colors.indigoAccent),
                  SizedBox(width: _width * .03),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _width*0.36,
                        height: _height*0.026,
                        margin: EdgeInsets.fromLTRB(0, _height*0.01, 0, 0),
                        child: AutoSizeText(
                          "Pickup Address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: _height*0.008,
                      ),
                      AutoSizeText(
                        widget.data.buildingNumber+','+widget.data.streetName+','+widget.data.locality+','+widget.data.pincode,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      )
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 10.0,
                      offset: Offset(0.5, 2.0),
                      spreadRadius: 1.0,
                    )
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              height: _height * .14,
              width: _width * .9,
              padding: EdgeInsets.fromLTRB(_width*0.02, _height*0.01, _width*0.02, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.star, size: _width*0.08, color: Colors.amber),
                  SizedBox(width: _width * .02),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _width*0.36,
                        height: _height*0.03,
                        margin: EdgeInsets.fromLTRB(0, _height*0.01, 0, 0),
                        child: AutoSizeText(
                          "Don't forget to rate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: _width*0.7,
                        height: _height*0.045,
                        child: AutoSizeText(
                          "Oh Teri! Kitchen to help your fellow foodies",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 10.0,
                      offset: Offset(0.5, 2.0),
                      spreadRadius: 1.0,
                    )
                  ]
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.05,
          )
        ],
      ),
    );
  }
}
Widget getdot(BuildContext context){
  return Padding(
    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.015),
    child: Icon(
      Icons.arrow_drop_down_circle,
      size: MediaQuery.of(context).size.width*0.015*0.9,
      color: Colors.grey[600],
    ),
  );
}
Widget geticon(BuildContext context,bool status){
  return Icon(
    Icons.check_circle,
    size: MediaQuery.of(context).size.width*0.015*3.1,
    color: status?Colors.teal:Colors.grey,
  );
}

class CategoryList extends StatelessWidget {
  Map data;
  List clist= [];
  CategoryList({this.data});
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    var listheight = 0.0;
    data.forEach((key, value) {
      listheight += (_height * 0.09);
      listheight += (_height * 0.05) * (data[key].length);
      clist.add(key);
    });
    return Container(
      height: listheight,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                height: _height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(_width*0.02, 0, _width*0.02, 0),
                      height: _height*0.06,
                      width: _width * 0.11,
                      child: Center(
                        child: Icon(
                          Icons.local_bar,
                          color: Colors.teal[500],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    Container(
                      // color: Colors.blue,
                      width: _width * 0.71,
                      height: _height*0.04,
                      margin: EdgeInsets.fromLTRB(0,_height*0.015, 0, 0),
                      child: AutoSizeText(
                        categoryInfoList[int.parse(clist[index])].name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, _width*0.02, 0, 0),
                      width: _width * 0.07,
                      height: _height * 0.036,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                          child: AutoSizeText(
                        data[clist[index]].length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: _height * 0.03,
              ),
              ProductList(
                plist: data[clist[index]],
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: _height * 0.01,
          );
        },
        itemCount: clist.length,
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List plist;
  const ProductList({Key key, this.plist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Container(
      height: (1.0 * plist.length * _height * 0.05),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: _height * 0.05,
            padding: EdgeInsets.fromLTRB(_width*0.06, 0, 0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_drop_down_circle,
                      size: _width*0.025,
                      color: Colors.teal,
                    ),
                    SizedBox(
                      width: _width * 0.03,
                    ),
                    Container(
                      // color: Colors.red,
                      width: _width * 0.65,
                      height: _height*0.027,
                      child: AutoSizeText(
                        plist[index]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      // color: Colors.blue,
                      alignment: Alignment.centerRight,
                      width: _width*0.16,
                      height: _height*0.025,
                      child: AutoSizeText(
                          (plist[index]['priceperpiece']).toString()+" x "+(plist[index]['quantity']).toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                  width: _width * 8,
                  margin: EdgeInsets.fromLTRB(_width*0.05, _width*0.02, _width*0.04, 0),
                ),
              ],
            ),
          );
        },
        itemCount: plist.length,
      ),
    );
  }
}
