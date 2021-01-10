import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/orderInfo.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:e_commerce/customer/orderdetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}


class _OrdersState extends State<Orders> {
  bool orderType = true;
  bool isLoaded =  false;
  List<OrderInfo> currentOrderData  = [];
  List<OrderInfo> pastOrderData  = [];

  Future<void> getOrderList() async{
    Requests request = new Requests(
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/getUserOrders'
    );
    var response = await request.getRequest();
    for(int i=0;i<response['data'].length;i++){
      OrderInfo orderInfo = OrderInfo(
        mobNumber: response['data'][i]['shopmob'].toString(),
        orderNo: response['data'][i]['id'].toString(),
        status: response['data'][i]['status'].toString(),
        storeName: response['data'][i]['storename'].toString(),
        total: response['data'][i]['total'].toString(),
        buildingNumber: response['data'][i]['buildingnumber'].toString(),
        locality: response['data'][i]['locality'].toString(),
        paymentTime: response['data'][i]['paymenttime'].toString(),
        pickupTime: response['data'][i]['pickuptime'].toString(),
        pincode: response['data'][i]['pincode'].toString(),
        placeTime: response['data'][i]['placetime'].toString(),
        processedTime: response['data'][i]['processedtime'].toString(),
        streetName: response['data'][i]['streetname'].toString()
      );
      if(orderInfo.status != "4" && orderInfo.status != "5"){
        currentOrderData.add(orderInfo);
      }else{
        pastOrderData.add(orderInfo);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderList().then((value) => {
      setState(() {
        isLoaded=true;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(_height*0.08),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height*0.03,),
              Container(
                height: _height*0.07,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          orderType = !orderType;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: _height * 0.067,
                            color: orderType ? Colors.grey[100] : Colors.white,
                            width: _width / 2,
                            padding: EdgeInsets.fromLTRB(_width*0.05, _height*0.02, 0, 0),
                            child: AutoSizeText(
                              "Current Orders",
                              style: TextStyle(
                                color: orderType
                                    ? Color.fromRGBO(30, 132, 127, 1)
                                    : Colors.grey,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            width: _width/ 2,
                            color: orderType
                                ? Color.fromRGBO(30, 132, 127, 1)
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          orderType = !orderType;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: _height * 0.067,
                            color: !orderType ? Colors.grey[100] : Colors.white,
                            width: _width / 2,
                            padding: EdgeInsets.fromLTRB(_width*0.1, _height*0.02, 0, 0),
                            child: AutoSizeText(
                              "Past Orders",
                              style: TextStyle(
                                color: !orderType
                                    ? Color.fromRGBO(30, 132, 127, 1)
                                    : Colors.grey,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            width: _width / 2,
                            color: !orderType
                                ? Color.fromRGBO(30, 132, 127, 1)
                                : Colors.grey,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: !isLoaded?Container(
          color: Colors.white,
          child: Center(child: SpinKitPouringHourglass(color: Colors.teal,)),
        ):ListView(
          children: <Widget>[
            Container(
                color: Colors.grey[200],
                alignment: Alignment.topLeft,
                height: orderType?((_height * .23)+_width*0.02)*currentOrderData.length:((_height * .2)+10)*pastOrderData.length,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: orderType?currentOrderData.length:pastOrderData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (orderType?currentOrderData.length==0?Text("No current orders"):
                      CurrentOrderCard(data: currentOrderData[index],):
                      pastOrderData.length==0?Text("No past order"):
                      PastOrderCard(data: pastOrderData[index],));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: _width*0.02,
                      );
                    }
                )
            )
          ],
        )
    );
  }
}

class PastOrderCard extends StatelessWidget {
  OrderInfo data;
  PastOrderCard({this.data});
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        debugPrint("Past Order");
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => OrderDetails(data: data,)));
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: _height * .2,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: _width * 0.015,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                ),
                Container(
                  width: _width * .9,
                  padding: EdgeInsets.fromLTRB(_width*0.044, _height*0.02, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: _width*0.21,
                            height: _height*0.024,
                            child: AutoSizeText(
                              "ORDER NO: ",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            height: _height*0.024,
                            width: _width*0.18,
                            child: AutoSizeText(
                              data.orderNo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: _width*0.03,),
                          data.status=="4"?Icon(Icons.check_circle,size: 16,color: Colors.green,):Icon(Icons.cancel,size: 16,color: Colors.red,)
                        ],
                      ),
                      SizedBox(
                        height: _height * .07,
                      ),
                      Container(
                        height: _height*0.037,
                        width: _width*0.55,
                        child: AutoSizeText(
                          data.storeName,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: _height*0.008,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.call,color: Colors.teal,size: 10,),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal,width: 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: _width*0.03,),
                          Container(
                            height: _height*0.03,
                            width: _width*0.3,
                            child: Text(
                              data.mobNumber,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _width*0.26,
                          ),
                          Container(
                            width: _width*0.22,
                            height: _height*0.024,
                            child: AutoSizeText(
                              "Total: "+data.total.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          // Icon(MdiIcons.)
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey[500],)
              ],
            ),
          ),
          Positioned(
            top: _height*.02,
            left: _width*0.7,
            child: Container(
              height: _height*0.025,
              width: _width*0.23,
              child: AutoSizeText(
                "Order Details",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.indigo,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentOrderCard extends StatelessWidget {
  OrderInfo data;
  CurrentOrderCard({this.data});
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        debugPrint("Order no: "+data.orderNo);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => OrderDetails(data: data,)));
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: _height * .23,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: _width * 0.015,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 132, 127, 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                ),
                Container(
                  width: _width * .9,
                  padding: EdgeInsets.fromLTRB(_width*0.044, _height*0.045, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: _width*0.21,
                            height: _height*0.024,
                            child: AutoSizeText(
                              "ORDER NO: ",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            height: _height*0.024,
                            width: _width*0.18,
                            child: AutoSizeText(
                                data.orderNo,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _height * .07,
                      ),
                      Container(
                        height: _height*0.037,
                        width: _width*0.55,
                        child: AutoSizeText(
                          data.storeName,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: _height*0.008,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              child: Icon(Icons.call,color: Colors.teal,size: 10,),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal,width: 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: _width*0.03,),
                          Container(
                            height: _height*0.03,
                            width: _width*0.3,
                            child: Text(
                              data.mobNumber,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _width*0.26,
                          ),
                          Container(
                            width: _width*0.22,
                            height: _height*0.024,
                            child: AutoSizeText(
                              "Total: "+data.total.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          // Icon(MdiIcons.)
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey[500],)
              ],
            ),
          ),
          Positioned(
            top: _height*.02,
            left: _width*0.7,
            child: Container(
              height: _height*0.025,
              width: _width*0.23,
              child: AutoSizeText(
                "Order Details",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.indigo,
                ),
                maxLines: 1,
              ),
            ),
          ),
          Positioned(
              top:  _height*.017,
              left: _width*0.06,
              child: Container(
                height: _height*0.024,
                width: _width*0.27,
                // color: Colors.red,
                child: AutoSizeText("ORDER STATUS: ",style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                  maxLines: 1,
                ),
              )
          ),
          Positioned(
              top:  _height*.017,
              left: _width*0.35,
              child: Container(
                height: _height*0.024,
                width: _width*0.3,
                // color: Colors.black,
                child: AutoSizeText(orderStatus[data.status],style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
                  maxLines: 1,
                ),
              )
          ),
          // Positioned(top:_width10*3.8,left: _width10*4,child: Container(height: 2,color: Colors.grey[400],width: _width*0.85,))
        ],
      ),
    );
  }
}