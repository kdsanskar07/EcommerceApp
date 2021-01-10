import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/store/Editbuisnessdetails.dart';
import 'package:e_commerce/store/editBusinesslocation.dart';
import 'package:e_commerce/store/helpers.dart';
import 'package:e_commerce/others/qr_generate.dart';
import 'package:e_commerce/store/schedule.dart';
import 'package:e_commerce/store/setBusinessHours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class Account extends StatefulWidget {
  UserInfo userInfo;
  StoreInfo storeInfo;
  Account({this.userInfo,this.storeInfo});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(color:Colors.teal,height: _height*0.03,),
          Stack(
            children: <Widget>[
              Container(
                height: _height*0.26,
                width: _width,
                color: Colors.grey[200],
                child: widget.storeInfo.img!=""?Image(width: _width*0.91, image: NetworkImage(widget.storeInfo.img), fit: BoxFit.fill):null,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, _height*0.15, 0, 0),
                height: _height*0.08,
                width: _width*0.6,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(_width*0.04, _height*0.013, _width*0.04, _height*0.013),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                  ),
                  child: AutoSizeText(
                    widget.storeInfo.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: (){
                  debugPrint("add business hours");
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => SetStoreOpenDays(storeInfo: widget.storeInfo, userInfo: widget.userInfo))
                  );
                },
                  child: Options(height: _height, width: _width,title: "Business Hours",lead: Icons.schedule)),
              InkWell(
              onTap: (){
                debugPrint("Edit Profile");
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => EditBuisnessDetails(storeInfo: widget.storeInfo, userInfo: widget.userInfo))
                );
              },
                  child: Options(height: _height, width: _width,title: "Edit Profile",lead: MdiIcons.accountEdit)),
              InkWell(
                  onTap: (){
                    debugPrint("Edit Business Address");
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => SetBusinessLocation(storeInfo: widget.storeInfo, userInfo: widget.userInfo))
                    );
                  },
                  child: Options(height: _height, width: _width,title: "Address",lead:Icons.location_on)),
              InkWell(
                onTap: (){
                  debugPrint("Manage Helpers");
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => Helper())
                  );
                },
                  child: Options(height: _height, width: _width,title: "Manage Helpers",lead:Icons.people)),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => QrGenerate())
                    );
                  },
                  child: Options(height: _height, width: _width,title: "Generate QR",lead: MdiIcons.qrcode)),
              InkWell(
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, "/homepage", (r) => false);
                },
                  child: Options(height: _height, width: _width,title: "Return Home",lead: Icons.home)
              ),
              Options(height: _height, width: _width,title: "Help",lead: MdiIcons.helpCircleOutline),
            ],
          )
        ],
      ),
    );
  }
}

class Options extends StatelessWidget {
  const Options({
    Key key,
    @required double height,
    @required double width,
    @required IconData lead,
    @required String title,
  }) : _height = height, _width = width,_lead = lead,_title = title,super(key: key);

  final double _height;
  final double _width;
  final IconData _lead;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: _height*.012),
      width: _width*.95,
      height: _height*.08,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:EdgeInsets.only(left:_width*.05),
            child: Icon(
              _lead,
              color: Colors.black,
              size: _width*.072,
            ),
          ),
          Padding(
            padding:EdgeInsets.only(left:_width*.05),
            child: Container(
                width: _width*.68,
                child: AutoSizeText(
                _title,
                  style: TextStyle(
                    fontSize: _width*.04,
                    fontFamily: "Roboto-Medium"
                  ),
            )
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: _width*.05,
          )
        ],
      ),
    );
  }
}
