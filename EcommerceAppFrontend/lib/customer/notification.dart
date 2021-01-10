import 'package:e_commerce/class/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';


class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationInfo> dataList = [
    NotificationInfo(
        heading: '30% sale at Mantras',
        discription: 'The Ultimate fashion destination is live now.',
        img:
            'https://nikitamenda.files.wordpress.com/2017/04/appnotification_slide-6.jpg'
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: AutoSizeText(
            'Notification',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
            maxLines: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: dataList.length != 0
          ? ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return false;
                    } else if (direction == DismissDirection.endToStart) {
                      return true;
                    }
                    return true;
                  },
                  onDismissed: (direction) {
                    setState(() {
                      dataList.removeAt(index);
                    });
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Container(child: new AutoSizeText("Item Dismissed."),),
                    ));
                  },
                  background: new Container(
                    color: Colors.white,
                    child: IconButton(
                      onPressed: (){},
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      iconSize: 55.0,
                    ),
                  ),
                  child: NotificationCard(data: dataList[index]),
                );
              },
            )
          : Center(
              child: Image(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80',
                ),
              ),
            ),
      backgroundColor: Colors.white,
    );
  }
}

class NotificationCard extends StatelessWidget {
  NotificationInfo data;

  NotificationCard({this.data});

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0, top: _height * .001, bottom: 0.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal,width: 1),
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(_width * .02, _height* .013, _width* .03, 0.0),
                color: Colors.white12,
                child: IconButton(
                  onPressed: (){},
                  icon: Icon(
                    Icons.camera,
                    color: Color.fromRGBO(30, 132, 127, 1),
                  ),
                  iconSize: 35.0,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, _height* .029, 0.0, 0.0),
                // color: Colors.red,
                height: _height * 0.09,
                width: _width* 0.8,
                child: AutoSizeText.rich(
                  TextSpan(
                    text: data.heading,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                    ),
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(_width * .02, _height* .013, _width* .03, _height*.009),
              //color: Colors.red,
              height: _height * 0.054,
              width: _width* 1,
              child: Container(
                child: AutoSizeText.rich(
                  TextSpan(
                      text: data.discription,
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                      )),
                  softWrap: true,
                ),
              ),
            ),
          ),
          Container(
            height:
                data.img == "" ? 0 : MediaQuery.of(context).size.height * .22,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              image: data.img == "" ?AssetImage('assets/images/S.jpg'):NetworkImage(
                data.img,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
* new Arrivals
* Order place
* */
