import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/authentication/login.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/customer/Bookmarks.dart';
import 'package:e_commerce/customer/aboutus.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/HelperHome.dart';
import 'package:e_commerce/store/businesshome.dart';
import 'package:e_commerce/store/businessregister.dart';
import 'package:e_commerce/customer/invitation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:e_commerce/customer/personaldetails.dart';
import 'package:e_commerce/class/user.dart';

class AppDrawer extends StatefulWidget {
  UserInfo userInfo ;

  AppDrawer({this.userInfo});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  StoreInfo storeInfo;
  bool getStore=false;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Future<void> getStoreInfo() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/store/getstoredetail'
    );
    var response = await request.getRequest();
    print(response['data'].toString());
    storeInfo = new StoreInfo(
      storeId: response['data']['id'].toString(),
      openingTime: response['data']['openingtime'].toString(),
      closingTime: response['data']['closingtime'].toString(),
      buildingNumber: response['data']['buildingnumber'].toString(),
      name: response['data']['name'].toString(),
      mob: response['data']['mob'].toString(),
      img: response['data']['img'].toString(),
      rating: response['data']['rating'].toString(),
      revenue: response['data']['revenue'].toString(),
      noOfOrders: response['data']['nooforders'].toString(),
      streetName: response['data']['streetname'].toString(),
      city: response['data']['city'].toString(),
      locality: response['data']['locality'].toString(),
      pinCode: response['data']['pincode'].toString(),
      isOpenOnFriday: response['data']['isopenfriday'],
      isOpenOnMonday: response['data']['isopenonmonday'],
      isOpenOnThursday: response['data']['isopenonthursday'],
      isOpenOnTuesday: response['data']['isopenontuesday'],
      isOpenOnWednesday: response['data']['isopenonwednesday'],
      isOpenOnSaturday: response['data']['isopenonsaturday'],
      isOpenOnSunday: response['data']['isopenonsunday'],
      isBookmark: 0,
      categoryList: [],
    );
    print(storeInfo.name);
  }

  @override
  void initState() {
    super.initState();
    if(widget.userInfo.type!="1"){
      // TODO
      getStoreInfo().then((value) => {
        print(storeInfo.name),
        setState(() {
          getStore=true;
        }),
      });
    }else{
      getStore=true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return getStore?Container(
      height: _height,
      width: _width * .8,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              debugPrint("Profile");
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => DetailsPage(userInfo: widget.userInfo)));
            },
            child: Container(
              height: _height * .2,
              color: Colors.teal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: _width * .05),
                  Padding(
                    padding: EdgeInsets.only(top: _height * .06),
                    child: Container(
                        height: _height * .08,
                        width: _width * .15,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: widget.userInfo.pic == ""
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              )
                            : Image(
                                image: NetworkImage(widget.userInfo.pic),
                                fit: BoxFit.fill,
                              )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: _height * .09,
                      ),
                      InkWell(
                        onTap: () {
                          print("Edit Profile.");
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: _width * .05),
                          child: Container(
                            width: _width*.45,
                            child: AutoSizeText(
                              widget.userInfo.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Roboto-Medium"
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: _width * .05, top: _height * .005),
                            child: Container(
                              width: _width * .4,
                              child: AutoSizeText(
                                widget.userInfo.email,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: "Roboto-Light"),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(width: _width * .06),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => Bookmark(userInfo:widget.userInfo)));
            },
            child: Padding(
              padding: EdgeInsets.only(top: _height * .025, left: _width * 0.05),
              child: ItemContainer(
                contentIcons: MdiIcons.home,
                contentText: "Bookmarks",
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          SizedBox(
            height: _height * .001,
            child: Padding(
              padding: EdgeInsets.only(left: _width * .05),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          InkWell(
            onTap: () {
              print("type: "+widget.userInfo.type);
              if (widget.userInfo.type=="2") {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => BusinessHome(userInfo:widget.userInfo,storeInfo: storeInfo,)));
              }
              if(widget.userInfo.type=="1"){
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Register(userInfo: widget.userInfo,)));
              }
              if(widget.userInfo.type=="3"){
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => HelperHome(storeInfo: storeInfo,)));
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: _width * 0.05),
              child: ItemContainer(
                contentIcons: MdiIcons.store,
                contentText: widget.userInfo.type!="1" ? storeInfo.name : "Add new Shop",
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          SizedBox(
            height: _height * .001,
            child: Padding(
              padding: EdgeInsets.only(left: _width * .05),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: _width * 0.05),
              child: ItemContainer(
                contentIcons: MdiIcons.accountPlus,
                contentText: "Invite People",
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => InvitePage()));
            },
          ),
          SizedBox(
            height: _height * .025,
          ),
          SizedBox(
            height: _height * .001,
            child: Padding(
              padding: EdgeInsets.only(left: _width * .05),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => AboutUs()));
            },
            child: Padding(
              padding: EdgeInsets.only(left: _width * 0.05),
              child: ItemContainer(
                contentIcons: MdiIcons.information,
                contentText: "About Us",
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          SizedBox(
            height: _height * .001,
            child: Padding(
              padding: EdgeInsets.only(left: _width * .05),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          InkWell(
            onTap: () async {
              await storage.delete(key: 'token');
              Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginPage())
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: _width * 0.05),
              child: ItemContainer(
                contentIcons: MdiIcons.logout,
                contentText: "Logout",
              ),
            ),
          ),
          SizedBox(
            height: _height * .025,
          ),
          SizedBox(
            height: _height * .001,
            child: Padding(
              padding: EdgeInsets.only(left: _width * .05),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: _height * .05,
          ),
          Padding(
            padding: EdgeInsets.only(left: _width * .25),
            child: Text(
              "Connect with us",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: "Roboto-Light",
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: _width * .2),
                    child: Container(
                      height: _height * .1,
                      width: _width * .08,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 2, color: Colors.blue[800])),
                      child: Image.asset("assets/images/facebook.jpg"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _width * .05),
                    child: Container(
                      height: _height * .1,
                      width: _width * .08,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 2, color: Colors.blue[500])),
                      child: Image.asset("assets/images/linkedin.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _width * .05),
                    child: Container(
                      height: _height * .1,
                      width: _width * .08,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 2, color: Colors.blue[600])),
                      child:
                          Image.asset("assets/images/twitter.png", scale: 20),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ):Container(
      height: _height,
      width: _width * .8,
      color: Colors.white,
    );
  }
}

class ItemContainer extends StatelessWidget {
  IconData contentIcons;
  String contentText;

  ItemContainer({this.contentIcons, this.contentText});

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          contentIcons,
        ),
        SizedBox(width: _width * .1),
        Container(
          width: _width * .3,
          child: Text(
            contentText,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: "Roboto-Light",
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: _width * .2,
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Color.fromRGBO(30, 132, 127, 1),
        )
      ],
    ));
  }
}
