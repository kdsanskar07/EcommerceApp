import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:e_commerce/class/businessorder.dart';
import 'package:e_commerce/class/orderInfo.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:e_commerce/class/category.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShopOrderDetails extends StatefulWidget {
  Function refresh;
  final BusinessOrder data;
  ShopOrderDetails({this.data,this.refresh});
  @override
  _ShopOrderDetailsState createState() => _ShopOrderDetailsState();
}

class _ShopOrderDetailsState extends State<ShopOrderDetails> {
  bool isLoaded = false;
  bool orderCancelled = false;
  bool isOrderReady = false;
  bool pickOrderStore = false;
  var data;
  Future<void> getOrderProduct() async{
    var bodyData = {
      'id': widget.data.orderId
    };
    Requests request = new Requests(
        bodyData: bodyData,
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/getOrderProduct'
    );
    var response = await request.postRequest();
    if(response == null){
      return;
    }
    if(response['success'] == true){
      data = response['data'];
    }
  }

  Future<void> cancelStoreOrder(orderId) async{
    var bodyData = {
      "orderId": orderId
    };
    Requests request = new Requests(
        bodyData: bodyData,
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/cancelStoreOrder'
    );
    orderCancelled = true;
    var response = await request.postRequest();
    if(response == null){
      orderCancelled = false;
      return;
    }
    if (response['success'] == false) {
      orderCancelled = false;
    }
  }

  Future<void> orderReady(orderId) async{
    var bodyData = {
      "orderId": orderId,
      "pickupTime": DateTime.now().toString()
    };
    Requests request = new Requests(
        bodyData: bodyData,
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/readyStoreOrder'
    );
    isOrderReady = true;
    var response = await request.postRequest();
    if(response == null){
      isOrderReady = false;
      return;
    }
    if (response['success'] == false) {
      isOrderReady = false;
    }
  }

  Future<void> pickStoreOrder(orderId,otp) async{
    var bodyData = {
      "orderId": orderId,
      "otp": otp
    };
    Requests request = new Requests(
        bodyData: bodyData,
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/pickStoreOrder'
    );
    pickOrderStore = true;
    var response = await request.postRequest();
    if (response['success'] == false) {
      setState(() {
        pickOrderStore = false;
      });
    }
  }

  Future<void> bottomSheet(orderId) async{
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final _textOtp= TextEditingController();
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.teal.withOpacity(0),
        builder: (context) =>
            Container(
              height: _height,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: _height * 0.2,
                  width: _width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        _width * 0.05, _height * 0.02, _width * 0.05, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: _width,
                          child: Center(
                            child: Container(
                              height: _height * 0.03,
                              width: _width * 0.2,
                              child: AutoSizeText(
                                "Enter OTP", style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(height: _height * 0.02,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[400],
                                width: 1,
                              )
                          ),
                          child: TextField(
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            controller: _textOtp,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[900],
                            ),
                            buildCounter: (BuildContext context,
                                { int currentLength, int maxLength, bool isFocused }) => null,
                            maxLength: 6,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: _height * 0.02,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: _width * 0.25,),
                            InkWell(
                              onTap: () {
                                debugPrint("cancel sending otp");
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: _height * 0.03,
                                width: _width * 0.15,
                                child: AutoSizeText("Cancel", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),),
                              ),
                            ),
                            SizedBox(width: _width * 0.1,),
                            InkWell(
                              onTap: () async{
                                  if(pickOrderStore == false){
                                  await pickStoreOrder(orderId,_textOtp.text);
                                    if(pickOrderStore==true){
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                              child: Container(
                                height: _height * 0.03,
                                width: _width * 0.3,
                                child: AutoSizeText(
                                  "Send Request", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal,
                                  fontSize: 18,
                                ),),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
    );
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
        )),
        shape: Border(bottom: BorderSide(color: Colors.teal,width: 1)),
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            debugPrint("Back");
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black),
        ),
        actions: [
          widget.data.storeStatus=="6"?InkWell(
              onTap: () async{
                await cancelStoreOrder(widget.data.orderId);
                if(orderCancelled == true){
                  Navigator.pop(context);
                }
              },
              child: Center(
                  child: Text("cancel",
                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,fontSize: 16
                    ),
                  )
              )
          ):Container(),
          SizedBox(width: _width*.05,),
        ],
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
        ],
      ),
        bottomNavigationBar:widget.data.storeStatus=="6"?InkWell(
          onTap: () async{
            await orderReady(widget.data.orderId);
            if(isOrderReady == true) {
              Navigator.pop(context);
            }
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
                _width * 0.04, 0, _width * 0.04, _height*0.02),
            height: _height * 0.07,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.teal,
            ),
            child: Center(
              child: AutoSizeText("Order ready",style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ),
                maxLines: 1,
              ),
            )
          )):widget.data.storeStatus=="3"?InkWell(
            onTap: () async{
              await bottomSheet(widget.data.orderId);
              if(pickOrderStore==true){
                Navigator.pop(context);
              }
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(
                    _width * 0.04, 0, _width * 0.04, _height*0.02),
                height: _height * 0.07,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.teal,
                ),
                child: Center(
                  child: AutoSizeText("Confirm OTP",style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                  ),
                    maxLines: 1,
                  ),
                )
            )
          ):Text(""),
    );
  }
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
    print(plist);
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
