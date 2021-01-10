import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/category.dart';
import 'package:e_commerce/class/productinfo.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/customer/cart.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/addProduct.dart';
import 'package:e_commerce/store/editProduct.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flip_card/flip_card.dart';

class CustomerShopProducts extends StatefulWidget {
  int categoryListIndex;
  CustomerShopProducts({this.categoryListIndex});

  @override
  _CustomerShopProductsState createState() => _CustomerShopProductsState();
}
class _CustomerShopProductsState extends State<CustomerShopProducts> {
  bool getProduct = false;
  List<ProductInfo> data = [];
  List<bool> isAddedToCart = [];
  bool clickedProduct = true;
  bool filterClicked = false;

  Future<void> getProductListInfo() async{
    data = [];
    isAddedToCart = [];
    final FlutterSecureStorage storage = FlutterSecureStorage();
    var cartStorageProducts = await storage.read(key: 'cartProducts');
    if(cartStorageProducts == null) {
      Map d = {
        "Hello":"null"
      };
      await storage.write(key: 'cartProducts', value: jsonEncode(d));
    }
    cartStorageProducts = await storage.read(key: 'cartProducts');
    Map decodedProducts = jsonDecode(cartStorageProducts);
    Requests request = new Requests(
        isHeader: true,
        bodyData: {'categoryId': widget.categoryListIndex},
        context: context,
        url: 'http://10.0.2.2:3000/product/getproductlist'
    );
    var response = await request.postRequest();
    print("res:: "+response.toString());
    print(response['data'].length);
    for(int i=0;i<response['data'].length;i++){
      print("value:"+ i.toString());
      ProductInfo temp = ProductInfo(
        id: response['data'][i]['id'],
        price: response['data'][i]['price'],
        name: response['data'][i]['name'],
        img: response['data'][i]['img'],
        description: response['data'][i]['description'],
        categoryId: response['data'][i]['categoryid'],
        totalQuantity: response['data'][i]['totalquantity'],
        unit: response['data'][i]['unit'],
      );
      data.add(temp);
      if(decodedProducts.containsKey(decodedProducts.containsKey(response['data'][i]['id'].toString()))){
        isAddedToCart.add(true);
      }else{
        isAddedToCart.add(false);
      }
    }
  }

  Future<void> addToCart(productId) async{
    var bodyData = {
      "productId": productId
    };
    Requests request = new Requests(
        isHeader: true,
        bodyData: bodyData,
        context: context,
        url: 'http://10.0.2.2:3000/order/addToCart'
    );
    var response = await request.postRequest();
    if(response!=null && response['success'] == true){
      setState(() {
        getProduct = false;
      });
      await getProductListInfo();
      final FlutterSecureStorage storage = FlutterSecureStorage();
      var cartStorageProducts = await storage.read(key: 'cartProducts');
      Map decodedProducts = jsonDecode(cartStorageProducts);
      decodedProducts[productId.toString()] = '1';
      await storage.write(key: 'cartProducts', value: jsonEncode(decodedProducts));
      setState(() {
        getProduct = true;
      });
    }
  }

  Widget ProductSearchCard(data,categoryListIndex,context,index){
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      speed: 300,
      front: Padding(
        padding: EdgeInsets.only(top: _height*.02, right: _width*.03, left: _width*.03),
        child: Container(
          padding: EdgeInsets.all(0),
          height: _height*.225,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.teal,width: 1),
            backgroundBlendMode: BlendMode.luminosity,
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Container(
                    height: _height*.225,
                    width: _width*0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(right: BorderSide(color: Colors.teal,width: 1)),
                    ),
                    child: data.img!=""?Image(
                      image: NetworkImage(data.img),
                      fit: BoxFit.fill,
                    ):null
                ),
              ),
              Flexible(
                flex: 9,
                child: Container(
                    height: _height*.225,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: _width*.58,
                                child: Padding(
                                  padding: EdgeInsets.only(left: _width*.025, top: _height*.02),
                                  child: Text(
                                    data.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 21,
                                        fontFamily: "Roboto-Medium"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: _height*.06,
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: _width*.025),
                              RichText(
                                text: TextSpan(
                                    text: "Offers : ",
                                    style: TextStyle(
                                        color: Colors.blueAccent
                                    ),
                                    children: <InlineSpan>[
                                      TextSpan(
                                          text: "300 rs. off",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto-Light"
                                          )
                                      )
                                    ]
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: _height*0.024,),
                        Column(
                          children: [
                            SizedBox(height: _height*.025,),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 3,
                            ),
                            Container(
                              height: _height*.054,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: _width*.05,
                                  ),
                                  Container(
                                    child: Text("\u20B9 "+ data.price,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontFamily: "Roboto-Medium"
                                        )
                                    ),
                                  ),
                                  SizedBox(width: _width*.1),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: _width*.002,
                                          child: Container(
                                            color: Colors.black,
                                            width: _width*.002,
                                          ),
                                        ),
                                        SizedBox(
                                          width: _width*.02,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            if(isAddedToCart[index]==true){
                                              Navigator.push(
                                                  context, CupertinoPageRoute(builder: (context) => Cart())
                                              );
                                            }else{
                                              addToCart(data.id);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: _width*.05),
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width*.025,
                                              ),
                                              Text(
                                                !isAddedToCart[index]?"Add to Cart":"Go to Cart",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontFamily: "Roboto-Medium"
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
      back: Padding(
          padding: EdgeInsets.only(top: _height*.02, right: _width*.03, left: _width*.03),
          child: Container(
            padding: EdgeInsets.all(0),
            height: _height*.225,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.teal,width: 1),
              backgroundBlendMode: BlendMode.luminosity,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  height: _height*.17,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    backgroundBlendMode: BlendMode.luminosity,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: AutoSizeText(
                        data.description,
                        style: TextStyle(
                            fontFamily: "Roboto-Light",
                            fontSize: 15,
                            color: Colors.black
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 3,
                ),
                Padding(
                  padding: EdgeInsets.only(top: _height*.005),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: _width*.25,
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: _width*.1,
                              child: Container(
                                color: Colors.yellowAccent,
                                width: _width*.005,
                              ),
                            ),
                            SizedBox(
                              width: _width*.025,
                            ),
                            AutoSizeText(
                              "Unit : "+ data.unit,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Roboto-Light"
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              presetFontSizes: [20,10,6],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProductListInfo().then((value) => {
      setState(() {
        getProduct=true;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black),
        ),
        title: Text(
          "Products",
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: getProduct?ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Visibility(
            visible: clickedProduct,
            child: Container(
                color: Colors.white,
                child: data.length>0?ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return ProductSearchCard(data[index],widget.categoryListIndex,context,index);
                    }
                )
                    : Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: _height*.18,left: _width*.04,right: _width*.04),
                      child: Image(
                        image: AssetImage("assets/images/NotFound.png"),
                      ),
                    ),
                  ),
                )
            ),
          ),
        ],
      ):Container(
        height: _height,
        width: _width * .8,
        color: Colors.white,
      ),
    );
  }
}