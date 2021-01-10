import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/businessorder.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/shoporderdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoaded = false;
  bool orderAccepted = false;
  List<BusinessOrder> data = [];
  List<BusinessOrder> originalData = [];

  Future<void> getStoreOrders() async{
    Requests request = new Requests(
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/getStoreOrders'
    );
    var response = await request.getRequest();
    if(response == null){
      return;
    }
    for(int i=0;i<response['data'].length;i++){
      var d = BusinessOrder(
        total: response['data'][i]['total'].toString(),
        orderId: response['data'][i]['id'].toString(),
        storeStatus: response['data'][i]['status'].toString()
      );
      data.add(d);
      originalData.add(d);
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
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: null,
        backgroundColor: Colors.teal,
        title: Text("Orders",style: TextStyle(
          color: Colors.white,
        ),),
        centerTitle: true,
        actions: <Widget>[
          DropdownButton(
              underline: Container(
                width: 0,
              ),
              icon: Icon(Icons.tune,color: Colors.white),
              items: [
                DropdownMenuItem(
                  onTap: (){
                    debugPrint("All");
                    setState(() {
                      data = originalData;
                    });
                  },
                  child: Container(
                    height: _height * 0.028,
                    width: _width * 0.06,
                    // color: Colors.red,
                    child: AutoSizeText("All",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),maxLines: 1,),
                  ),
                  value: 0,
                ),
                DropdownMenuItem(
                  onTap: (){
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
                  },
                  value: 1,
                  child: Container(
                    height: _height * 0.028,
                    width: _width * 0.18,
                    //color: Colors.red,
                    child: AutoSizeText("Pending",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),maxLines: 1,),
                  ),
                ),
                DropdownMenuItem(
                  onTap: (){
                    debugPrint("Accepted");
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
                  },
                  child: Container(
                    height: _height * 0.028,
                    width: _width * 0.18,
                    // color: Colors.red,
                    child: AutoSizeText("Accepted",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ), maxLines: 1,),
                  ),
                  value: 2,
                ),
                DropdownMenuItem(
                  onTap: (){
                    debugPrint("Declined");
                    data = originalData;
                    List<BusinessOrder> d = [];
                    data.forEach((element) {
                      if(element.storeStatus=="5"){
                        d.add(element);
                      }
                    });
                    setState(() {
                      data = d;
                    });
                  },
                  child: Container(
                    height: _height * 0.028,
                    width: _width * 0.18,
                    // color: Colors.red,
                    child: AutoSizeText("Declined",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ), maxLines: 1,),
                  ),
                  value: 3,
                ),
                DropdownMenuItem(
                  onTap: (){
                    debugPrint("Picked");
                    data = originalData;
                    List<BusinessOrder> d = [];
                    data.forEach((element) {
                      if(element.storeStatus=="4"){
                        d.add(element);
                      }
                    });
                    setState(() {
                      data = d;
                    });
                  },
                  child: Container(
                    height: _height * 0.028,
                    width: _width * 0.14,
                  //  color: Colors.red,
                    child: AutoSizeText("Picked",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,),
                  ),
                  value: 0,
                ),
              ],
              onChanged: (value) {
              }),
          SizedBox(width: _width*0.08,)
        ],
      ),
      body: !isLoaded?Container(
        color: Colors.white,
        child: Center(child: SpinKitPouringHourglass(color: Colors.teal,)),
      ):ListView.builder(
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
    );
  }
}
class OrderCard extends StatefulWidget {
  BusinessOrder data;
  int index;
  OrderCard({this.data,this.index});
  @override
  _OrderCardState createState() => _OrderCardState();
}
class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          height: _height * 0.11,
          width: _width,
          margin: EdgeInsets.fromLTRB(
              _width * 0.04, _height * 0.022, _width * 0.04, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.teal, width: 1)),
          child: Padding(
            padding: EdgeInsets.all(_width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: _width*0.4,
                  height: _height*0.027,
                  child: AutoSizeText(
                    "Order no: "+widget.data.orderId,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
                ),
                // SizedBox(
                //   height: _height * 0.01,
                // ),
                Container(
                  height: _height*0.025,
                  width: _width*0.22,
                  child: AutoSizeText(
                    "Total : \u20B9 "+widget.data.total,
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
        ),
        Positioned(
          top: _height*0.045,
          left: _width*0.76,
          child: Container(
            height: _height*0.027,
            width: _width*0.17,
            child: Center(
              child: AutoSizeText(storeStatus[widget.data.storeStatus],style: TextStyle(
                color: storeStatus[widget.data.storeStatus]=="Accepted"?Colors.green:storeStatus[widget.data.storeStatus]=="Declined"?Colors.red:storeStatus[widget.data.storeStatus]=="Picked"?Colors.indigo:Colors.tealAccent,
                fontWeight: FontWeight.w500
              ),
                maxLines: 1,
              ),
            ),
          ),
        ),
        Positioned(
          top: _height*0.08,
          left: _width*0.85,
          child: Icon(Icons.arrow_forward_ios,size: 16,),
        )
      ],
    );
  }
}
