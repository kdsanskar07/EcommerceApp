import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/complete33.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/class/category.dart';

class NewCategory extends StatefulWidget {
  UserInfo userInfo;
  StoreInfo storeInfo;
  NewCategory({this.storeInfo,this.userInfo});

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  bool isPressedDone = false;

  void sendStoreDetails() async {
    Requests requests = new Requests(
      url: 'http://10.0.2.2:3000/store/register',
      isHeader: true,
      context: context,
      bodyData: widget.storeInfo.getStore(),
    );
    var response = await requests.postRequest();
    isPressedDone=false;
    if(response!=null){
      widget.storeInfo.storeId=response['data']['id'].toString();
      print('storeId: '+widget.storeInfo.storeId);
      Navigator.push(
          context, CupertinoPageRoute(
        builder: (context) => Complete33(userInfo : widget.userInfo,storeInfo:widget.storeInfo),
      )
      );
    }else{
      widget.storeInfo.categoryList=[];
    }
  }

  Widget ItemCard(int index,BuildContext context){
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        setState(() {
          categoryInfoList[index].isPresentInStore = !categoryInfoList[index].isPresentInStore;
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
                    image: AssetImage(categoryInfoList[index].imgPath),
                  ),
                ),
                Padding(
                  child: Text(
                    categoryInfoList[index].name,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto-Medium'
                    ),
                  ),
                  padding: EdgeInsets.only(top: _height*.03),
                ),
              ],
            ),
            categoryInfoList[index].isPresentInStore?Align(
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
            Navigator.pop(context);
          },
            icon: IconButton(
              onPressed: (){
                if(isPressedDone==false){
                  isPressedDone=true;
                  for(int index=0;index<10;index++){
                    if(categoryInfoList[index].isPresentInStore){
                      widget.storeInfo.categoryList.add(index);
                    }
                  }
                  sendStoreDetails();
                }
              },
                icon: Icon(Icons.check)
            ),
            color: Colors.black,
          ),
          SizedBox(width: _width*0.04,),
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
              ItemCard(0, context),
              ItemCard(1, context),
            ],
          ),
          Row(
            children: [
              ItemCard(2, context),
              ItemCard(3, context),
            ],
          ),
          Row(
            children: [
              ItemCard(4, context),
              ItemCard(5, context),
            ],
          ),
          Row(
            children: [
              ItemCard(6, context),
              ItemCard(7, context),
            ],
          ),
          Row(
            children: [
              ItemCard(8, context),
              ItemCard(9, context),
            ],
          ),
        ],
      ),
    );
  }
}
