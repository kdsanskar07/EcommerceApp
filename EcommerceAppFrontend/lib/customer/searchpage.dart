import 'dart:ui';
import 'package:e_commerce/class/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:e_commerce/class/shop.dart';
import 'package:flip_card/flip_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Search"
        ),
      ),
      body: GetBody(),
    );
  }
}
List<Product> product = [
  Product(
      address: 'xyz street',
      img: "http://www.pngall.com/wp-content/uploads/1/Mobile-PNG-File.png",
      name: 'Samsung Galaxy',
      shop: 'CurioCity',
      price: 1000,
      totalRating: 0,
      description: "This is the description of the product and i have to wrap this text anyway possible."
  ),
  Product(
      address: 'xyz street',
      img: "http://www.pngall.com/wp-content/uploads/1/Mobile-PNG-File.png",
      name: 'Samsung Galaxy',
      shop: 'CurioCity',
      price: 2000,
      totalRating: 0,
      description: "This is the description of the product and i have to wrap this text anyway possible."
  ),
  Product(
      address: 'xyz street',
      img: "http://www.pngall.com/wp-content/uploads/1/Mobile-PNG-File.png",
      name: 'Samsung Galaxy',
      shop: 'CurioCity',
      price: 3000,
      totalRating: 0,
      description: "This is the description of the product and i have to wrap this text anyway possible."
  ),
  Product(
      address: 'xyz street',
      img: "http://www.pngall.com/wp-content/uploads/1/Mobile-PNG-File.png",
      name: 'Samsung Galaxy',
      shop: 'CurioCity',
      price: 4000,
      totalRating: 3,
      description: "This is the description of the product and i have to wrap this text anyway possible."
  ),
  Product(
      address: 'xyz street',
      img: "http://www.pngall.com/wp-content/uploads/1/Mobile-PNG-File.png",
      name: 'Samsung Galaxy',
      shop: 'CurioCity',
      price: 5000,
      totalRating: 5,
      description: "This is the description of the product and i have to wrap this text anyway possible."
  ),
];

class GetBody extends StatefulWidget {
  @override
  _GetBodyState createState() => _GetBodyState();
}

class _GetBodyState extends State<GetBody> {
  bool clickedProduct = true;
  bool filterClicked = false;
  int _sortFinalVal = 0;
  List<Shop> shop = [
    Shop(
      address: 'fv',
      avgDeliveryTime: 90,
      img:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80',
      isDelivery: false,
      name: 'CurioCity',
      numoforders: 3221,
      rating: 4.4,
      categoryValue: 1,
    ),
    Shop(
      address: 'fv',
      avgDeliveryTime: 90,
      img:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80',
      isDelivery: true,
      name: 'CurioCity',
      numoforders: 3221,
      rating: 4.4,
      categoryValue: 1,
    ),
    Shop(
      address: 'fv',
      avgDeliveryTime: 90,
      img:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80',
      isDelivery: true,
      name: 'CurioCity',
      numoforders: 3221,
      rating: 4.4,
      categoryValue: 1,
    ),
    Shop(
      address: 'fv',
      avgDeliveryTime: 90,
      img:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80',
      isDelivery: true,
      name: 'CurioCity',
      numoforders: 3221,
      rating: 4.4,
      categoryValue: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          height: _height*.085,
          color: Colors.teal,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: _height*.005, left: _width*.025, right: _width*.025),
                child: Container(
                  height: _height*.055,
                  padding: EdgeInsets.symmetric(horizontal: _width*.01),
                  child: CupertinoTextField(
                    keyboardType: TextInputType.text,
                    placeholder: 'Search',
                    placeholderStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontFamily: 'HelveticaBold',
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 6.0, 9.0, 6.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  clickedProduct = true;
                });
              },
              child: Container(
                height: _height*.054,
                width: (MediaQuery.of(context).size.width) / 2,
                color: clickedProduct?Colors.teal[600]:Colors.teal[400],
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: _width*.1,
                    ),
                    Icon(MdiIcons.tshirtV,color: Colors.white),
                    SizedBox(
                      width: _width*.02,
                    ),
                    AutoSizeText(
                      "Products",
                      style: TextStyle(
                          fontFamily: "Helevetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  clickedProduct = false;
                });
              },
              child: Container(
                height: _height*.054,
                width: (MediaQuery.of(context).size.width) / 2,
                color: clickedProduct?Colors.teal[400]:Colors.teal[600],
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: _width*.13,
                    ),
                    Icon(MdiIcons.store,color: Colors.white),
                    SizedBox(
                      width: _width*.02,
                    ),
                    AutoSizeText(
                      "Shops",
                      style: TextStyle(
                          fontFamily: "Helevetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Container(
          height: _height*.06,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: _width*.05,
              ),
              Text(
                "Search Results : ${clickedProduct?product.length:shop.length}",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "HelveticaBold",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: _width*.5,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    filterClicked = !filterClicked;
                  });
                },
                color: Colors.black,
                icon: Icon(MdiIcons.sortAscending),
              )
            ],
          ),
        ),
        Stack(
          children: [
            Visibility(
              visible: clickedProduct,
              child: Container(
                  color: Colors.grey[300],
                  child: product.length>0?ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        return ProductSearchCard(productVar: product[index]);
                      }
                      )
                      : Container(
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: _height*.12,left: _width*.04,right: _width*.04),
                            child: Image(
                            image: AssetImage("assets/images/NotFound.png"),
                        ),
                          ),
                  ),
                  )
              ),
              replacement: Container(
                  color: Colors.grey[300],
                  child: shop.length>0?ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: shop.length,
                      itemBuilder: (context, index) {
                        return ShopCard(shopVar: shop[index]);
                      }
                  )
                      : Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: _height*.12,left: _width*.04,right: _width*.04),
                        child: Image(
                          image: AssetImage("assets/images/NotFound.png"),
                        ),
                      ),
                    ),
                  )
              ),
            ),
            Visibility(
              visible: filterClicked,
              child: Positioned(
                width: MediaQuery.of(context).size.width,
                height: 5000,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 2,sigmaX: 2),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          height: _height*.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Divider(thickness: .5,color: Colors.grey),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:25.0,top: 10),
                                  child: Text(
                                    "Sort by",
                                    style: TextStyle(
                                        fontFamily: "Roboto-Medium",
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: _height*.01 ),
                              buildRadioListTile(0,"Relevance"),
                              buildRadioListTile(1,"Price low to high"),
                              buildRadioListTile(2,"Price high to low"),
                              buildRadioListTile(3,"By Popularity"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
  RadioListTile<int> buildRadioListTile(int _value,String _text) {
    return RadioListTile(
      activeColor: Colors.blue,
      title: Text(_text),
      value: _value,
      groupValue: _sortFinalVal,
      onChanged: (int value) {
        setState(() {
          _sortFinalVal = value;
          if(_sortFinalVal == 1)
            {
              product.sort((a,b) => a.price.compareTo(b.price));
            }
          else if(_sortFinalVal == 2)
          {
            product.sort((a,b) => b.price.compareTo(a.price));
          }
          else if(_sortFinalVal == 3)
          {
            product.sort((a,b) => b.rating.compareTo(a.rating));
          }
          filterClicked = false;
        });
      },
    );
  }
}
class ProductSearchCard extends StatefulWidget {
  final Product productVar;
  @override
  ProductSearchCard({this.productVar});

  @override
  _ProductSearchCardState createState() => _ProductSearchCardState();
}

class _ProductSearchCardState extends State<ProductSearchCard> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      speed: 300,
      front: Padding(
        padding: EdgeInsets.only(top: _height*.008, right: _width*.02, left: _width*.02),
        child: Container(
          padding: EdgeInsets.all(0),
          height: _height*.225,
          width: _width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            backgroundBlendMode: BlendMode.luminosity,
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: Container(
                      height: _height*.225,
                      color: Colors.green,
                      child: Image(
                          image: NetworkImage(widget.productVar.img))),
                ),
              ),
              Flexible(
                flex: 9,
                child: Container(
                    height: _height*.225,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: _width*.6,
                            child: Padding(
                              padding: EdgeInsets.only(left: _width*.025, top: _height*.02),
                              child: AutoSizeText(
                                widget.productVar.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontFamily: "Roboto-Medium"
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                presetFontSizes: [21,15],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: _width*.6,
                            child: Padding(
                              padding: EdgeInsets.only(left: _width*.025, top: _height*.01),
                              child: AutoSizeText(
                                widget.productVar.shop,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: "Roboto-Light"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _height*.05,
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
                                    width: _width*.2,
                                    child: AutoSizeText("\u20B9 "+ widget.productVar.price.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontFamily: "Roboto-Medium"
                                        ),
                                      presetFontSizes: [15,10,5],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: _width*.05),
                                  InkWell(
                                    onTap: () {
                                      print("Added to cart");
                                    },
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: _width*.002,
                                            child: Container(
                                              color: Colors.black,
                                              width: _width*.002,
                                            ),
                                          ),
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
                                            "Add to Cart",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontFamily: "Roboto-Medium"
                                            ),
                                          ),
                                        ],
                                      ),
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
          padding: EdgeInsets.only(top: _height*.008, right: _width*.02, left: _width*.02),
          child: Container(
            padding: EdgeInsets.all(0),
            height: _height*.225,
            width: _width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              backgroundBlendMode: BlendMode.luminosity,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  height: _height*.17,
                  width: _width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    backgroundBlendMode: BlendMode.luminosity,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.productVar.description,
                        style: TextStyle(
                          fontFamily: "Roboto-Light",
                          fontSize: 15,
                          color: Colors.black
                        ),
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
                      InkWell(
                        onTap: () {
                          print("Added to cart");
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: _width*.005,
                                child: Container(
                                  color: Colors.yellowAccent,
                                  width: _width*.005,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: _width*.05),
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: _width*.025,
                              ),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontFamily: "Roboto-Light"
                                ),
                              ),
                            ],
                          ),
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
}

class ShopCard extends StatelessWidget {
  final Shop shopVar;
  ShopCard({this.shopVar});
  @override
  Widget build(BuildContext context) {
    var _width= MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        debugPrint(this.shopVar.name);
      },
      child: Container(
        height: _height*0.35,
        width: _width*0.95,
        margin: EdgeInsets.fromLTRB(_width*0.02, _height*0.01, _width*0.02, 0),
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
                width: _width*0.98,
                height: _height*0.23,
                color: Colors.grey[100],
                child: shopVar.img!=""?Image(image: NetworkImage(shopVar.img), fit: BoxFit.fill,):null,
              ),
            ),
            SizedBox(height: _height*0.02,),
            Container(
              width: _width*0.98,
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
                          shopVar.getcategory(),
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





