import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/cards/share.dart';
import 'package:e_commerce/class/businessorder.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/account.dart';
import 'package:e_commerce/store/shoporderdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:e_commerce/store/buisnessorder.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:e_commerce/store/category.dart';

class BusinessHome extends StatefulWidget {
  UserInfo userInfo ;
  StoreInfo storeInfo;
  BusinessHome({this.userInfo,this.storeInfo});
  @override
  _BusinessHomeState createState() => _BusinessHomeState();
}
class _BusinessHomeState extends State<BusinessHome> {
  var _selectedTab = _SelectedTab.storeHome;
  bool isLoaded = false;
  bool orderAccepted = false;
  List<BusinessOrder> data = [];
  int ordertype=1;
  List<BusinessOrder> originalData = [];

  Future<void> getStoreOrders() async{
    Requests request = new Requests(
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/getStoreOrders'
    );
    var response = await request.getRequest();
    for(int i=0;i<response['data'].length;i++){
      var d = BusinessOrder(
          total: response['data'][i]['total'].toString(),
          orderId: response['data'][i]['id'].toString(),
          storeStatus: response['data'][i]['status'].toString()
      );
      if(d.storeStatus != "5" && d.storeStatus != "4"){
        data.add(d);
        originalData.add(d);
      }
    }
  }

  Future<void> acceptOrders(index) async{
    if(!orderAccepted) {
      orderAccepted = true;
      var bodyData = {
        "orderId": data[index].orderId,
        "processedTime":DateTime.now().toString()
      };
      Requests request = new Requests(
          bodyData: bodyData,
          isHeader: true,
          context: context,
          url: 'http://10.0.2.2:3000/order/acceptStoreOrders'
      );
      var response = await request.postRequest();
      if(response == null){
        return;
      }
      if (response['success'] == false) {
        orderAccepted = false;
      }else{
        setState(() {
          data[index].storeStatus = "6";
        });
      }
    }
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  void initState() {
    super.initState();
    getStoreOrders().then((value) => {
      setState((){
        isLoaded = true;
      })
    });
  }

  Future<void> refresh() async{
    data = [];
    originalData =[];
    setState(() {
      ordertype = 1;
      orderAccepted = false;
      isLoaded = false;
    });
    await getStoreOrders();
    setState(() {
      isLoaded = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        bottomNavigationBar: DotNavigationBar(
          unselectedItemColor: Colors.grey[700],
          dotIndicatorColor: Colors.black,
          selectedItemColor: Colors.teal,
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          onTap: _handleIndexChanged,
          margin: EdgeInsets.fromLTRB(_width*0.05, 0,_width*0.05, _width*0.012),
          items: [
            /// Store-Home
            DotNavigationBarItem(
              icon: Icon(Icons.business),
            ),
            /// Store-orders
            DotNavigationBarItem(
              icon: Icon(Icons.receipt),
            ),
            /// Category
            DotNavigationBarItem(
              icon: Icon(Icons.list),
            ),
            /// Account
            DotNavigationBarItem(
              icon: Icon(Icons.account_box),
            ),
          ],
        ),
      body: _selectedTab==_SelectedTab.storeHome?Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0,_height*0.28,0,0),
                padding: EdgeInsets.fromLTRB(_width*0.05,0,_width*0.0,0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: _width*0.18,
                      height: _height*0.028,
                      margin:EdgeInsets.fromLTRB(0, _width*0.04, 0, 0),
                      child: AutoSizeText(
                        "Overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: _height*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: _height*0.13,
                          width: _height*0.21,
                          padding: EdgeInsets.all(_width*0.05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.teal,width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: _width*0.2,
                                  height: _height*0.03,
                                  child: AutoSizeText(
                                    "ORDERS",
                                    style: TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                  )
                              ),
                              SizedBox(height: _width*0.01,),
                              Text(widget.storeInfo.noOfOrders,style: TextStyle(color: Colors.black87,fontSize: 19,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: _width*0.095,
                        ),
                        Container(
                          height: _height*0.13,
                          width: _height*0.21,
                          padding: EdgeInsets.all(_width*0.05),
                          decoration: BoxDecoration(
                              color: Colors.white,
                            border: Border.all(color: Colors.teal,width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: _width*0.2,
                                  height: _height*0.03,
                                  child: AutoSizeText(
                                    "REVENUE",
                                    style: TextStyle(color: Colors.black87,fontSize: 17,fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                  )
                              ),
                              SizedBox(height: _width*0.01,),
                              Text("\u20B9 "+widget.storeInfo.revenue,style: TextStyle(color: Colors.black87,fontSize: 19,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _width*0.04,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width:_width*0.26,
                          height: _height*0.028,
                          child: AutoSizeText(
                            "Active Orders",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: _width*0.42,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              _selectedTab=_SelectedTab.orderslist;
                            });
                          },
                          child: Container(
                            width: _width*0.15,
                            height: _height*0.026,
                            child: AutoSizeText(
                              "View All",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.arrow_forward_ios,size: 16,color: Colors.black87,)
                      ],
                    ),
                    SizedBox(height: _height*0.04,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            setState(() {
                              ordertype=1;
                              data = originalData;
                            });
                          },
                          child: Container(
                            height: _height*0.05,
                            width: _width*0.15,
                            decoration: BoxDecoration(
                              border: Border.all(color: ordertype==1?Colors.teal:Colors.grey[500],),
                              borderRadius:BorderRadius.all(Radius.elliptical(50, 50)),
                              color: ordertype==1?Colors.grey[300]:Colors.white,
                            ),
                            child: Center(child: AutoSizeText("All",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: ordertype==1?Colors.teal:Colors.grey[600],
                            ),
                            maxLines: 1,
                            )
                            ),
                          ),
                        ),
                        SizedBox(width: _width*0.022,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              ordertype=2;
                              data = originalData;
                              List<BusinessOrder> d = [];
                              data.forEach((element) {
                                if(element.storeStatus=="2"){
                                  d.add(element);
                                }
                              });
                              setState(() {
                                data = d;
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ordertype==2?Colors.grey[300]:Colors.white,
                                border: Border.all(color: ordertype==2?Colors.teal:Colors.grey[500],),
                                borderRadius:BorderRadius.all(Radius.elliptical(50, 50))
                            ),
                            height: _height*0.05,
                            width: _width*0.25,
                            child: Center(child: AutoSizeText("Pending",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: ordertype==2?Colors.teal:Colors.grey[600],
                            ),
                            maxLines: 1,
                            )),
                          ),
                        ),
                        SizedBox(width: _width*0.022,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              ordertype=3;
                              data = originalData;
                              List<BusinessOrder> d = [];
                              data.forEach((element) {
                                if(element.storeStatus=="6"){
                                  d.add(element);
                                }
                              });
                              setState(() {
                                data = d;
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ordertype==3?Colors.grey[300]:Colors.white,
                                border: Border.all(color: ordertype==3?Colors.teal:Colors.grey[500],),
                                borderRadius:BorderRadius.all(Radius.elliptical(50, 50))
                            ),
                            height: _height*0.05,
                            width: _width*0.23,
                            child: Center(child: AutoSizeText("Accepted",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: ordertype==3?Colors.teal:Colors.grey[600],
                            ),
                            maxLines: 1,
                            )),
                          ),
                        ),
                        SizedBox(width: _width*0.022,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              ordertype=4;
                              data = originalData;
                              List<BusinessOrder> d = [];
                              data.forEach((element) {
                                if(element.storeStatus=="3"){
                                  d.add(element);
                                }
                              });
                              setState(() {
                                data = d;
                              });
                            });
                          },
                          child: Container(
                            height: _height*0.05,
                            width: _width*0.20,
                            decoration: BoxDecoration(
                              border: Border.all(color: ordertype==4?Colors.teal:Colors.grey[500],),
                              borderRadius:BorderRadius.all(Radius.elliptical(50, 50)),
                              color: ordertype==4?Colors.grey[300]:Colors.white,
                            ),
                            child: Center(child: AutoSizeText("Ready",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: ordertype==4?Colors.teal:Colors.grey[600],
                            ),
                              maxLines: 1,
                            )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isLoaded?Container(
                height: _height*0.133*data.length,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async{
                          if(data[index].storeStatus =="2"){
                            await acceptOrders(index);
                          }else{
                            orderAccepted = true;
                          }
                          if(orderAccepted == true){
                            isLoaded = false;
                            await Navigator.push(
                                context, CupertinoPageRoute(builder: (context) =>
                                ShopOrderDetails(data: data[index])));
                            await refresh();
                          }
                        },
                        child: OrderCard(
                          data: data[index],index: index,
                        ),
                      );
                    },
                    itemCount: data.length
                ),
              ):Container()
            ],
          ),
          shareCard(context, widget.storeInfo),
        ],
      ):_selectedTab==_SelectedTab.orderslist?OrderPage():_selectedTab==_SelectedTab.category?Category(userInfo: widget.userInfo):_selectedTab==_SelectedTab.account?Account(userInfo: widget.userInfo,storeInfo: widget.storeInfo,):null,
    );
  }
}

enum _SelectedTab {storeHome,orderslist,category,account}


