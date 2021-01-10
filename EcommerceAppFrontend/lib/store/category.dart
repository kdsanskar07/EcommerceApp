import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/shopproducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/category.dart';

class Category extends StatefulWidget {
  UserInfo userInfo ;
  Category({this.userInfo});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool getCategoryList = false;
  List<int> categoryInfoIndex= [];
  List<CategoryInfo> data = [];

  Future<void> getCategoryListInfo() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/categorystore/getcategorylist'
    );
    var response = await request.getRequest();
    print("value: "+response['data'].toString());
    print(response['data']['categoryList'].length);
    for(var i=0;i<response['data']['categoryList'].length;i++){
      categoryInfoIndex.add(response['data']['categoryList'][i]);
      CategoryInfo temp = CategoryInfo(
        imgPath: categoryInfoList[response['data']['categoryList'][i]].imgPath,
        name: categoryInfoList[response['data']['categoryList'][i]].name,
        noOfProduct: response['data']['noOfProductList'][i],
        isPresentInStore: true,
      );
      data.add(temp);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategoryListInfo().then((value) => {
      setState(() {
        getCategoryList=true;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text("Categories"),
        centerTitle: true,
      ),
      body: getCategoryList?ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                debugPrint(data[index].name);
              },
              child: CategoryCard(
                curIndex:categoryInfoIndex[index],
                index: index,
                categoryList: data,
                userInfo: widget.userInfo,
              ),
            );
          },
          itemCount: data.length
      ):Container(
      height: _height,
      width: _width * .8,
      color: Colors.white,
    ),
    );
  }
}
class CategoryCard extends StatefulWidget {
  int index;
  int curIndex;
  List<CategoryInfo> categoryList;
  UserInfo userInfo ;
  CategoryCard({this.index,this.categoryList,this.userInfo,this.curIndex});
  @override
  _CategoryCardState createState() => _CategoryCardState(categoryList[index]);
}
class _CategoryCardState extends State<CategoryCard> {
  CategoryInfo currentCategory;
  _CategoryCardState(this.currentCategory);
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _heigth = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: (){
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => ShopProducts(userInfo:widget.userInfo,categoryListIndex:widget.curIndex,categoryList: widget.categoryList,))
            );
          },
          child: Container(
            height: _heigth * 0.114,
            width: _width,
            margin: EdgeInsets.fromLTRB(
                _width * 0.04, _heigth * 0.022, _width * 0.04, 0),
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
                    height: _heigth * 0.027,
                    width: _width * 0.7,
                    // color: Colors.red,
                    child: AutoSizeText(
                      currentCategory.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: _heigth * 0.01,
                  ),
                  Container(
                    height: _heigth * 0.025,
                    width: _width * 0.75,
                    //color: Colors.red,
                    child: AutoSizeText(
                      currentCategory.noOfProduct.toString() + " Product listed",
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
        ),
        Positioned(
          left: _width*0.85,
          top: _heigth*0.07,
          child: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 18,),
        )
      ],
    );
  }
}
