import 'package:e_commerce/class/businessorder.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/store/buisnessorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HelperHome extends StatefulWidget {
  StoreInfo storeInfo;
  HelperHome({this.storeInfo});
  @override
  _HelperHomeState createState() => _HelperHomeState();
}

class _HelperHomeState extends State<HelperHome> {
  List<BusinessOrder> data = [
    BusinessOrder(orderId: "6551-1515", total: "20",storeStatus: "Accepted"),
    BusinessOrder(orderId: "4517-5545", total: "15",storeStatus: "Declined"),
    BusinessOrder(orderId: "4552-2254", total: "5",storeStatus: "Pending"),
    BusinessOrder(orderId: "4552-2444", total: "35",storeStatus: "Picked"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.teal,width: 1)),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        title: Text(widget.storeInfo.name,style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                debugPrint(data[index].orderId);
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
