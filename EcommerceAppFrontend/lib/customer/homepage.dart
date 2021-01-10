import 'package:e_commerce/cards/shopcard.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/customer/notification.dart';
import 'package:e_commerce/customer/setlocationchange.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:e_commerce/class/category.dart';
import 'package:e_commerce/customer/orders.dart';
import 'package:e_commerce/customer/drawer.dart';
import 'package:e_commerce/customer/cart.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:e_commerce/others/Scan.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  UserInfo userInfo ;
  HomePage({this.userInfo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool getPincode = false;
  var _selectedTab = _SelectedTab.home;
  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<StoreInfo> storeData=[];
  List<StoreInfo> duplicateStoreData=[];
  Future<void> getPincodeStore ()async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/store/getstoredetailpincode'
    );
    var response = await request.getRequest();
    print(response);
    print(response['data'].toString());
    print("jhsuaydgbvgbsdgiv");
    print(response['data'].length);
    for(var i=0 ;i<response['data'].length;i++){
      StoreInfo temp = StoreInfo(
        storeId: response['data'][i]['id'].toString(),
        mob: response['data'][i]['mob'].toString(),
        buildingNumber: response['data'][i]['buldingnumber'].toString(),
        streetName: response['data'][i]['streetname'].toString(),
        locality: response['data'][i]['locality'].toString(),
        pinCode: response['data'][i]['pincode'].toString(),
        name: response['data'][i]['name'].toString(),
        openingTime: response['data'][i]['openingtime'].toString(),
        closingTime: response['data'][i]['closingtime'].toString(),
        img: response['data'][i]['img'].toString(),
        rating: response['data'][i]['rating'].toString(),
        revenue: response['data'][i]['revenue'].toString(),
        noOfOrders: response['data'][i]['nooforders'].toString(),
        isOpenOnMonday: response['data'][i]['isopenonmonday'],
        isOpenOnTuesday: response['data'][i]['isopenontuesday'],
        isOpenOnWednesday: response['data'][i]['isopenonwednesday'],
        isOpenOnThursday: response['data'][i]['isopenthursday'],
        isOpenOnFriday: response['data'][i]['isopenonfriday'],
        isOpenOnSaturday: response['data'][i]['isopenonsaturday'],
        isOpenOnSunday: response['data'][i]['isopenonsunday'],
        city: response['data'][i]['city'].toString(),
        categoryList: response['data'][i]['categoryList'],
      );
      storeData.add(temp);
      duplicateStoreData.add(temp);
    }

  }

  @override
  void initState() {
    super.initState();
    getPincodeStore().then((value) => {
      setState(() {
        getPincode=true;
      }),
    });

  }

  void refresh(temp){
    setState(() {
      storeData = temp;
    });
  }

  Widget getBody(context,userInfo,storeData) {

    var _width=MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        Container(
          height: _height*0.35,
          padding: EdgeInsets.fromLTRB(_width*0.02, 0, _width*0.04, 0),
          decoration: BoxDecoration(
            color: Colors.teal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: _height*0.04,
                width: _width*0.7,
                margin: EdgeInsets.fromLTRB(_width*0.02, 0, 0, 0),
                child: AutoSizeText(
                  "What would You like to",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  maxLines: 1,
                ),
              ),
              Container(
                  height: _height*0.048,
                  width: _width*0.2,
                  // color: Colors.white,
                  margin: EdgeInsets.fromLTRB(_width*0.02, 0, 0, 0),
                  child: AutoSizeText(
                    'buy ?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 36,
                    ),
                    maxLines: 1,
                  )
              ),
              SizedBox(
                height: _height*0.01,
              ),
              Container(
                width: _width*0.95,
                height: _height*0.058,
                padding: EdgeInsets.fromLTRB(_width*0.02, 0, 0, 0),
                child: CupertinoTextField(
                  keyboardType: TextInputType.text,
                  placeholder: 'Search',
                  placeholderStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: _width*0.05,
                  ),
                  prefix: Padding(
                    padding:
                    EdgeInsets.fromLTRB(_width*0.02, _height*0.01, _width*0.02, _height*0.01),
                    child: Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                  ),
                  suffix: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list),
                    iconSize: 26,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                  width: _width*0.4,
                  height: _height*0.024,
                  margin: EdgeInsets.fromLTRB(_width*0.025, _height*0.015, 0, 0),
                  child: AutoSizeText(
                    'Or search by category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  )
              ),
              SizedBox(
                height: _height*0.015,
              ),
              Container(
                height: _height*0.102,
                margin: EdgeInsets.fromLTRB(_width*0.03, 0, 0, 0),
                child: ListView.builder(
                  itemCount: categoryInfoList.length,
                  itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin:EdgeInsets.fromLTRB(0, 0, _width*0.015, 0),
                        child: InkWell(
                          onTap: () {
                            storeData = duplicateStoreData;
                            List<StoreInfo> temp = [];
                            for (var i = 0; i < storeData.length; i++){
                              bool isContain = false;
                              for(int j=0;j<storeData[i].categoryList.length;j++){
                                if(storeData[i].categoryList[j] == index){
                                  isContain = true;
                                }
                              }
                              if(isContain){
                                temp.add(storeData[i]);
                              }
                            }
                            refresh(temp);
                          },
                          child: CategoryCard(
                            iconVar: Icon(Icons.book),
                            textVar: categoryInfoList[index].name,
                          ),
                      ));
                    },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: _height*0.03,),
        Container(
          height: _height*0.025,
          width: _width*0.5,
          padding: EdgeInsets.fromLTRB(_width*0.05, 0, 0, 0),
          child: AutoSizeText(
            'Nearby Shops',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
        ),
        !getPincode?Text('Loading'):Container(
          height: storeData.length * (_height*0.39),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: storeData.length,
              itemBuilder: (BuildContext context, int index) {
                return ShopCard(
                  shopVar: storeData[index],
                  userInfo: userInfo,
                );
              }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(userInfo : widget.userInfo),
      appBar: _selectedTab == _SelectedTab.home ?AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.sort),
          color: Colors.white,
          iconSize: 26,
          onPressed: () {
          _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.local_grocery_store),
            color: Colors.white,
            iconSize: 26,
            onPressed: () {
              debugPrint("Cart");
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Cart())
              );
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.qrcodeScan),
            color: Colors.white,
            iconSize: 22,
            onPressed: () {
              debugPrint("Scan");
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => CodeScan())
              );
            },
          ),
          SizedBox(
            width: _width*0.02,
          ),
        ],
      ):null,
      body: _selectedTab == _SelectedTab.home ? getBody(context,widget.userInfo,storeData) : _selectedTab== _SelectedTab.orderslist?Orders():_selectedTab == _SelectedTab.notifications?NotificationPage():_selectedTab==_SelectedTab.setlocation?SetLocationChange(userInfo: widget.userInfo):null,
      bottomNavigationBar: DotNavigationBar(
        unselectedItemColor: Colors.grey[700],
        dotIndicatorColor: Colors.black,
        selectedItemColor: Colors.teal,
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        margin: EdgeInsets.fromLTRB(_width*0.05, 0,_width*0.05, _width*0.012),
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          /// orders
          DotNavigationBarItem(
            icon: Icon(Icons.receipt),
          ),
          /// location
          DotNavigationBarItem(
            icon: Icon(Icons.edit_location),
          ),
          /// notification
          DotNavigationBarItem(
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab {home,orderslist,setlocation,notifications}





class CategoryCard extends StatelessWidget {
  final Icon iconVar;
  final String textVar;
  CategoryCard({this.iconVar, this.textVar});

  @override
  Widget build(BuildContext context) {
    var _width=MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    return Container(
      height: _height*0.102,
      width: _width*0.205,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.whatshot
          ),
          Container(
            width: _width*0.18,
            height: _height*0.02,
            child: Center(
              child: AutoSizeText(
                textVar,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                ),
                maxLines: 2,
                softWrap: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}