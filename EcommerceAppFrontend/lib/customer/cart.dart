import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:e_commerce/class/cartProduct.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


int getTotal(data){
  int total=0;
  for(int i=0;i<data.length;i++){
    total+=(int.parse(data[i].quantity)*int.parse(data[i].priceperpiece));
  }
  return total;
}
int getDiscount(){
  int total=0;
  return total;
}
int getPlatformHandlingFee(){
  int total=0;
  return total;
}
int getToBePaid(data) => getTotal(data)+getPlatformHandlingFee()-getDiscount();

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}


class _CartState extends State<Cart> {
  List<cartProduct> data = [];
  bool getCartOrders = false;
  bool anyOrder = true;
  bool isCheckOut = false;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> getCartOrdersDetails() async {
    Requests request = new Requests(
        isHeader: true,
        context: context,
        url: 'http://10.0.2.2:3000/order/getCartDetails'
    );
    var response = await request.getRequest();
    if(response['data']['numOfOrders'] == 0){
      anyOrder = false;
      return;
    }
    response['data'] = response['data']['orderDetails'];
    for(int i=0;i<response['data'].length;i++){
      var cartStorageProducts = await storage.read(key: 'cartProducts');
      print(cartStorageProducts);
      if(cartStorageProducts == null) {
        Map d = {
          "Hello":"null"
        };
        await storage.write(key: 'cartProducts', value: jsonEncode(d));
      }
      cartStorageProducts = await storage.read(key: 'cartProducts');
      print(cartStorageProducts);
      Map decodedProducts = jsonDecode(cartStorageProducts);
      var quantity;
      if(!decodedProducts.containsKey(response['data'][i]['id'].toString())) {
        decodedProducts[response['data'][i]['id'].toString()] = '1';
        await storage.write(key: 'cartProducts', value: jsonEncode(decodedProducts));
        quantity = '1';
      }
      else {
        quantity = decodedProducts[response['data'][i]['id'].toString()];
      }
      print(decodedProducts);
      cartProduct temp = cartProduct(
        id: response['data'][i]['id'],
        name: response['data'][i]['name'],
        priceperpiece: response['data'][i]['price'],
        quantity: quantity,
        shopName: response['data'][i]['shopName'],
      );
      data.add(temp);
    }
  }

  Future<void> checkOut() async{
    var bodyData = [];
    if(!isCheckOut) {
        for (int i = 0; i < data.length; i++) {
          var d = {
            'placeTime': DateTime.now().toString(),
            'paymentTime': DateTime.now().toString(),
            'id': data[i].id,
            'quantity': data[i].quantity
          };
          bodyData.add(d);
        }
        print(bodyData);
        Requests request = new Requests(
            bodyData: bodyData,
            isHeader: true,
            context: context,
            url: 'http://10.0.2.2:3000/order/checkoutOrders'
        );
        isCheckOut = true;
        var response = await request.postRequest();
        if (response['success'] == false) {
          setState(() {
            isCheckOut = false;
          });
        }else{
          await storage.delete(key: 'cartProducts');
          Navigator.pop(context);
        }
    }
  }

  Future<void> resetData() async{
    data = [];
    setState(() {
      getCartOrders = false;
    });
    await getCartOrdersDetails();
    setState(() {
      getCartOrders = true;
    });
  }

  void callback(data) {
    setState(() {
      this.data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getCartOrdersDetails().then((value) => {
      setState(() {
        print(data);
        getCartOrders=true;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            debugPrint("Back");
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        shape: Border(bottom: BorderSide(color: Colors.teal,width: 1)),
        elevation: 0,
        title: Text("SHOPPING BAG",style: TextStyle(
          color: Colors.black,
        ),),
      ),
      backgroundColor: Colors.grey[100],
      body: !getCartOrders?
      Container(
        color: Colors.white,
        child: Center(child: SpinKitPouringHourglass(color: Colors.teal,)),
      ):
          anyOrder?
      ListView(
        children:<Widget>[
          Container(
            color: Colors.white,
            height: _height*0.045,
            margin: EdgeInsets.fromLTRB(_width*0.03, 3, _width*0.03, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.teal,
                  width: _width*0.17,
                  height: 2,
                ),
                Icon(Icons.check_circle,size: 12,color: Colors.teal,),
                Container(
                  width: _width*0.072,
                  height: _height*0.025,
                  child: Center(
                    child: AutoSizeText(
                      "Bag",
                      style: TextStyle(
                      fontSize: 12,
                    ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: _width*0.18,
                  height: 2,
                ),
                Icon(Icons.arrow_drop_down_circle,size: 10,color: Colors.grey,),
                Container(
                  width: _width*0.15,
                  height: _height*0.025,
                  child: Center(
                    child: AutoSizeText(
                      " Payment ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: _width*0.165,
                  height: 2,
                ),
                Icon(Icons.arrow_drop_down_circle,size: 10,color: Colors.grey,),
                Container(
                  width: _width*0.12,
                  height: _height*0.025,
                  // color: Colors.red,
                  child: Center(
                    child: AutoSizeText(
                      " Pickup ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _height*0.01,),
          Container(
            height: data.length*_height*0.16,
            child: ListView.separated(
              itemCount: data.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context,int index){
                return ProductCard(index: index,data:data,callback:callback,resetData:resetData);
                },
              separatorBuilder: (BuildContext context,int index) => Container(
                padding: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
                margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
                height: 1,
                color: Colors.black38,
              ),
            ),
          ),
          SizedBox(height: _height*0.02,),
          Container(
            margin: EdgeInsets.fromLTRB(_width*0.03, 0, _width*0.03, 0),
            padding: EdgeInsets.fromLTRB(_width*0.03, _width*0.03, _width*0.03, _width*0.03),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: AutoSizeText("Item Total(MRP)",style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700]
                      ),),
                      width: _width*0.27,
                      height: _height*0.022,
                    ),
                    SizedBox(width: _width*0.37,),
                    Container(
                      alignment: Alignment.topRight,
                      width: _width*0.24,
                      height: _height*0.022,
                      child: AutoSizeText(
                          "\u20B9 "+getTotal(data).toString(),style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[900],
                      ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _width*0.015,),
                Row(
                  children: <Widget>[
                    Container(
                      width: _width*0.15,
                      height: _height*0.022,
                      child: AutoSizeText("Discount",style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]
                          ),
                          maxLines: 1,
                      ),
                    ),
                    SizedBox(width: _width*0.49,),
                    Container(
                      alignment: Alignment.topRight,
                      width: _width*0.24,
                      height: _height*0.022,
                      child: AutoSizeText(
                        "\u20B9 "+getDiscount().toString(),style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[900],
                      ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _width*0.04,),
                Container(
                  height: 1,
                  color: Colors.black38,
                ),
                SizedBox(height: _width*0.04,),
                Row(
                  children: <Widget>[
                    Container(
                      width: _width*0.37,
                      height: _height*0.022,
                      child: AutoSizeText("Platform Handling Fee",style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]
                      ),
                      maxLines: 1,
                      ),
                    ),
                    SizedBox(width: _width*0.27,),
                    Container(
                      alignment: Alignment.topRight,
                      height: _height*0.022,
                      width: _width*0.24,
                      child: AutoSizeText(
                        "\u20B9 "+getPlatformHandlingFee().toString(),style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[900],
                      ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _width*0.04,),
                Container(
                  height: 1,
                  color: Colors.black38,
                ),
                SizedBox(height: _width*0.04,),
                Row(
                  children: <Widget>[
                    Container(
                      height: _height*0.027,
                      width: _width*0.2,
                      child: AutoSizeText(
                        "To Be Paid",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: _width*0.44,),
                    Container(
                      alignment: Alignment.topRight,
                      // color: Colors.teal,
                      height: _height*0.027,
                      width: _width*0.24,
                      child: AutoSizeText(
                        "\u20B9 "+getToBePaid(data).toString(),style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
            height: _width*0.1,
            margin: EdgeInsets.fromLTRB(_width*0.03, 0, _width*0.03, 0),
            padding: EdgeInsets.fromLTRB(_width*0.03,0,_width*0.03,0),
            color: Colors.greenAccent.withOpacity(0.4),
            child: Row(
              children: <Widget>[
                Container(
                  width: _width*0.4,
                  height: _height*0.027,
                  child: AutoSizeText("Total Saving "+"\u20B9"+getDiscount().toString(),style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _height*0.02,),
          Container(
            margin: EdgeInsets.fromLTRB(_width*0.03, 0, _width*0.03, 0),
            padding: EdgeInsets.all(_width*0.03),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width:_width*0.7,
                      height: _height*0.055,
                      alignment: Alignment.topLeft,
                      child: TextField(
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Have a promocode? Enter',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                      ),
                    ),
                    SizedBox(width: _width*0.05,),
                    InkWell(
                      onTap: (){debugPrint("Apply");},
                      child: Container(
                        width: _width*0.11,
                        height: _height*0.027,
                        child: AutoSizeText("Apply",style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.w500
                        ),
                          maxLines: 1,
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 1,color: Colors.grey,),
              ],
            ),
          ),
        ]
      ):
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: _height*0.1,),
                Image.asset("assets/images/emptyCart.png"),
                Text("There is nothing in your bag",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,letterSpacing: 1.1),),
                SizedBox(height: _height*0.02,),
                Text("Let's add some items",style: TextStyle(fontSize: 16),)
              ],
            ),
          ),
      bottomNavigationBar: !anyOrder?Container(height: 0,):Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: _height*0.1,
        padding: EdgeInsets.fromLTRB(_width*0.03, _height*0.014, _width*0.03, _height*0.014),
        child: InkWell(
          onTap: () async{
            debugPrint('checkout');
            await checkOut();
          },
          child: Container(
            width: _width*0.8,
            height: _height*0.072,
            padding: EdgeInsets.fromLTRB(_width*0.07, _height*0.012, _width*0.01,_height*0.012),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: _height*0.024,
                      width: _width*0.17,
                      child: AutoSizeText("To be paid",style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                      maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 1,),
                    Container(
                      width: _width*0.13,
                      height: _height*0.02,
                      child: AutoSizeText("\u20B9 "+getToBePaid(data).toString(),style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                SizedBox(width: _width*0.04,),
                Container(
                  height: _width*0.1,
                  width: 1,
                  color: Colors.white,
                ),
                SizedBox(width: _width*0.31,),
                Container(
                  width: _width*0.22,
                  height: _height*0.027,
                  child: AutoSizeText("CHECKOUT",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  ),
                ),
                SizedBox(width: _width*0.01,),
                Icon(Icons.arrow_forward,color: Colors.white,size: 24,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  int index;
  List<cartProduct> data;
  Function callback;
  Function resetData;
  ProductCard({this.index,this.data,this.callback,this.resetData});
  @override
  _ProductCardState createState() => _ProductCardState(index: index,data:data);
}

class _ProductCardState extends State<ProductCard> {
  int index;
  List<cartProduct> data;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  bool removedButtonClicked = false;
  _ProductCardState({this.index,this.data});

  Future<void> removeProduct() async{
      var bodyData = {
        'id': data[index].id
      };
      Requests request = new Requests(
          bodyData: bodyData,
          isHeader: true,
          context: context,
          url: 'http://10.0.2.2:3000/order/removeProduct'
      );
      var response = await request.postRequest();
      if(response['success'] == true){
        var cartStorageProducts = await storage.read(key: 'cartProducts');
        Map decodedProducts = jsonDecode(cartStorageProducts);
        await decodedProducts.remove(data[index].id.toString());
        await storage.write(key: 'cartProducts', value: jsonEncode(decodedProducts));
        await this.widget.resetData();
      }
    }

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Container(
      height: _height*0.16,
      padding: EdgeInsets.fromLTRB(_width*0.032,_width*0.035,_width*0.033,0),
      margin: EdgeInsets.fromLTRB(_width*0.03,0,_width*0.03,0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: _width*0.6,
                height: _height*0.027,
                child: AutoSizeText(
                  data[index].name.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(width: _width*0.06,),
              Container(
                alignment: Alignment.topRight,
                width: _width*0.212,
                height: _height*0.027,
                child: AutoSizeText(
                    "\u20B9 "+(int.parse(data[index].priceperpiece)*int.parse(data[index].quantity)).toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: _height*0.015,),
          Container(
            width: _width*0.6,
            height: _height*0.021,
            child: AutoSizeText(
              "Seller: "+data[index].shopName.toString(),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              maxLines: 1,
            ),
          ),
          SizedBox(height: _height*0.02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () async{
                  debugPrint("Remove item");
                  await removeProduct();
                },
                child: Container(
                  height: _height*0.025,
                  width: _width*0.15,
                  child: AutoSizeText(
                    "Remove",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(width: _width*0.43,),
              InkWell(
                  onTap: () async {
                    var r = await storage.read(key: 'cartProducts');
                    Map decodedData = jsonDecode(r);
                    var id = data[index].id.toString();
                    var quantity = decodedData[id];
                    quantity = int.parse(quantity);
                    if(quantity>1){
                      quantity--;
                      decodedData[id] = quantity.toString();
                      await storage.write(key: 'cartProducts', value: jsonEncode(decodedData));
                      setState(() {
                          data[index].quantity = quantity.toString();
                          this.widget.callback(data);
                      });
                    }},
                  child: Icon(Icons.remove_circle_outline,size: _width*0.08,color: Colors.teal,)
              ),
              SizedBox(width: _width*0.05,),
              Container(
                padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: AutoSizeText(
                  data[index].quantity.toString(),
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(width: _width*0.05,),
              InkWell(
                onTap: () async{
                  debugPrint("Quantity increased");
                  var r = await storage.read(key: 'cartProducts');
                  Map decodedData = jsonDecode(r);
                  var id = data[index].id.toString();
                  var quantity = decodedData[id];
                  quantity = int.parse(quantity);
                  if(quantity<9){
                    quantity++;
                    decodedData[id] = quantity.toString();
                    await storage.write(key: 'cartProducts', value: jsonEncode(decodedData));
                    setState(() {
                      data[index].quantity = quantity.toString();
                      this.widget.callback(data);
                    });
                  }
                  },
                  child: Icon(Icons.add_circle,size: _width*0.08,color: Colors.teal,)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

