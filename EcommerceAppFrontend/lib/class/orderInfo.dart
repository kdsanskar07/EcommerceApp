class OrderInfo {
  String storeName;
  String mobNumber;
  String total;
  String orderNo;
  String status;
  String placeTime;
  String paymentTime;
  String processedTime;
  String pickupTime;
  String buildingNumber;
  String streetName;
  String locality;
  String pincode;
  OrderInfo(
      {this.storeName,
      this.mobNumber,
      this.total,
      this.status,
      this.orderNo,
      this.placeTime,
      this.buildingNumber,
      this.locality,
      this.paymentTime,
      this.pickupTime,
      this.pincode,
      this.processedTime,
      this.streetName});
}

Map orderStatus = {
  "1": "Unplace",
  "2": "In transit",
  "3": "Ready to pickup",
  "4": "Picked",
  "5": "Cancel",
  "6": "Accepted",
};
