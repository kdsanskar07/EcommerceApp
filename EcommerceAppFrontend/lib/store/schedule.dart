import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  bool isSwitched = false;
  String finalTime = "10:00 - 21:00";
  int openHour = 10;
  int openMintue = 00;
  int closingHour = 10;
  int closingMintue = 00;

 Widget dayContainer(String day){
   var _width = MediaQuery.of(context).size.width;
   var _height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .02, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .02, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .01,
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal,
            // backgroundColor: Color.fromRGBO(0, 0, 128,1),
            child: Text(
              day[0],
              style: TextStyle(color: Colors.white , fontSize: 24),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .06,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                // color: Colors.red,
                height: _height * 0.035,
                width: _width * 0.4,
                child: AutoSizeText(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              // SizedBox(height:MediaQuery.of(context).size.height * .007 ,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // color: Colors.red,
                    height: _height * 0.03,
                    width: _width * 0.334,
                    child: AutoSizeText(finalTime,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                  ),
                  Switch(
                    hoverColor: Colors.black,
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeColor: Colors.teal,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * .02),
                child: InkWell(
                  child: Container(
                    // color: Colors.red,
                    height: _height * 0.03,
                    width: _width * 0.2,
                    child: AutoSizeText(
                      'Change',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Business Hours',
          style: TextStyle(color: Colors.black ,fontSize: 24, fontWeight: FontWeight.w400),
        ),
        //centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {Navigator.of(context).pop();},
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            dayContainer('Monday'),
            dayContainer('Tuesday'),
            dayContainer('Wednesday'),
            dayContainer('Thrusday'),
            dayContainer('Friday'),
            dayContainer('Saturday'),
            dayContainer('Sunday'),
          ],
        ),
      ),
    );
  }
}

