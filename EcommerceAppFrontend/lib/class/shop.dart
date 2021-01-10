import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shop {
  String mobNumber;
  String name;
  String img;
  double rating;
  String address;
  int numoforders;
  bool isDelivery;
  int avgDeliveryTime;
  int categoryValue;
  bool isOpenOnMonday;
  bool isOpenOnTuesday;
  bool isOpenOnWednesday;
  bool isOpenOnThursday;
  bool isOpenOnFriday;
  bool isOpenOnSaturday;
  bool isOpenOnSunday;
  Shop(
      {this.name,
      this.address,
      this.avgDeliveryTime,
      this.img,
      this.isDelivery,
      this.numoforders,
      this.rating,
      this.categoryValue,
      this.isOpenOnFriday,
      this.isOpenOnMonday,
      this.isOpenOnSaturday,
      this.isOpenOnSunday,
      this.isOpenOnThursday,
      this.isOpenOnTuesday,
      this.isOpenOnWednesday,
      this.mobNumber,});

  String getcategory() {
    if (this.categoryValue == 1) {
      return "Restaurant and cafe";
    }
    return "";
  }


  String getDelivery() {
    if (this.isDelivery) {
      return "Delivery available";
    } else {
      return "Self pickup";
    }
  }

  Widget getDeliveryIcon() {
    if (this.isDelivery) {
      return Icon(
        Icons.directions_bike,
        size: 18,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
        child: Icon(
          Icons.directions_run,
          size: 18,
        ),
      );
    }
  }
}
