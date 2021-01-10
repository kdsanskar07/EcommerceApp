import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map isProviding = {
  "Restaurants": false,
  "Health and Care": false,
  "Mobile and accessories": false,
  "Camera": false
};
class SelectCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.teal,width: 1)),
        actions: <Widget>[
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.check),
            color: Colors.black,
          )
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: _width*.06,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Select Category",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Roboto-Medium",
              fontSize: 20
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
            children: [
              Item(name: "Restaurants",img: 'assets/images/restaurants.png',isProviding: isProviding['Restaurants']),
              Item(name: "Health and Care",img: 'assets/images/health.png',isProviding: isProviding['Health and Care'],),
            ],
          ),
          Row(
            children: [
              Item(name: "Mobile and accessories",img: 'assets/images/mobile.png',isProviding: isProviding['Mobile and accessories'],),
              Item(name: "Camera",img: 'assets/images/camera.png',isProviding: isProviding['Camera'],),
            ],
          ),
          Row(
            children: [
              Item(name: "Restaurants",img: 'assets/images/health.png',isProviding: false,),
              Item(name: "Restaurants",img: 'assets/images/health.png',isProviding: false,),
            ],
          ),
          Row(
            children: [
              Item(name: "Restaurants",img: 'assets/images/health.png',isProviding: false,),
              Item(name: "Restaurants",img: 'assets/images/health.png',isProviding: false,),
            ],
          ),Row(
            children: [
              Item(name: "Restaurants",img: 'assets/images/health.png',isProviding: false,),
              Item(name: "Restaurants",img: 'assets/images/health.png',isProviding: false,),
            ],
          ),
        ],
      ),
    );
  }
}

class Item extends StatefulWidget {
  Item({
    Key key,
    String name,
    String img,
    bool isProviding
  }) : _name = name,_img = img,_isProviding = isProviding, super(key: key);

  String _name;
  String _img ;
  bool _isProviding;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        print("clicked");
        setState(() {
          print(isProviding[widget._name]);
          isProviding[widget._name] = !isProviding[widget._name];
        });
      },
      child: Container(
        height: _width*.5,
        width: _width*.5,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(width: 1,color: Colors.grey[400]),
                right: BorderSide(color: Colors.grey[400],width: 1)
            )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                    height: _width*.25,
                    width: _width*.25,
                    image: AssetImage(widget._img),
                  ),
                ),
                Padding(
                  child: Text(
                    widget._name,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto-Medium'
                    ),
                  ),
                  padding: EdgeInsets.only(top: _height*.03),
                ),
              ],
            ),
            isProviding[widget._name]?Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: _width*.04,top: _height*.03),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.teal,
                ),
              ),
            ):Container()
          ],
        ),
      ),
    );
  }
}



