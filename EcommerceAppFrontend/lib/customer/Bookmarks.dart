import 'package:e_commerce/cards/shopcard.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/class/shop.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/others/requests.dart';

class Bookmark extends StatefulWidget {
  UserInfo userInfo ;

  Bookmark({this.userInfo});
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  List<StoreInfo> storeData=[];
  bool isLoaded = false;
  Future<void> getBookmarkStore() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/bookmark/fetch'
    );
    var response = await request.getRequest();
    print(response);
    print(response['result'].toString());
    print("jhsuaydgbvgbsdgiv");
    print(response['result']['storeList'].length);
    for(var i=0 ;i<response['result']['storeList'].length;i++){
      StoreInfo temp = StoreInfo(
        storeId: response['result']['storeList'][i]['id'].toString(),
        mob: response['result']['storeList'][i]['mob'].toString(),
        buildingNumber: response['result']['storeList'][i]['buldingnumber'].toString(),
        streetName: response['result']['storeList'][i]['streetname'].toString(),
        locality: response['result']['storeList'][i]['locality'].toString(),
        pinCode: response['result']['storeList'][i]['pincode'].toString(),
        name: response['result']['storeList'][i]['name'].toString(),
        openingTime: response['result']['storeList'][i]['openingtime'].toString(),
        closingTime: response['result']['storeList'][i]['closingtime'].toString(),
        img: response['result']['storeList'][i]['img'].toString(),
        rating: response['result']['storeList'][i]['rating'].toString(),
        revenue: response['result']['storeList'][i]['revenue'].toString(),
        noOfOrders: response['result']['storeList'][i]['nooforders'].toString(),
        isOpenOnMonday: response['result']['storeList'][i]['isopenonmonday'],
        isOpenOnTuesday: response['result']['storeList'][i]['isopenontuesday'],
        isOpenOnWednesday: response['result']['storeList'][i]['isopenonwednesday'],
        isOpenOnThursday: response['result']['storeList'][i]['isopenthursday'],
        isOpenOnFriday: response['result']['storeList'][i]['isopenonfriday'],
        isOpenOnSaturday: response['result']['storeList'][i]['isopenonsaturday'],
        isOpenOnSunday: response['result']['storeList'][i]['isopenonsunday'],
        city: response['result']['storeList'][i]['city'].toString(),
      );
      storeData.add(temp);
    }
  }

  @override
  void initState() {
    super.initState();
    getBookmarkStore().then((value) => {
      setState((){
        isLoaded = true;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text('Bookmarks',
        style: TextStyle(
          color: Colors.black,
              fontSize: 20
        ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
       body: !isLoaded?Text('Loading'):Container(
          height: storeData.length * (_height*0.39),
          child: ListView.builder(
              itemCount: storeData.length,
              itemBuilder: (BuildContext context, int index) {
                return ShopCard(
                  shopVar: storeData[index],
                  userInfo: widget.userInfo,
                );
              }),
        ),
    );
  }
}
