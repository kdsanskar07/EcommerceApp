
class CategoryInfo{
  String name;
  String imgPath;
  String noOfProduct;
  bool isPresentInStore;
  CategoryInfo({
    this.name,
    this.noOfProduct,
    this.imgPath,
    this.isPresentInStore,
  });
}

List<CategoryInfo> categoryInfoList = [
  new CategoryInfo(name: 'Musical', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Toys', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Books', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Grocery', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Bags', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Restaurant', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Health', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Software', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Bakery', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
  new CategoryInfo(name: 'Jewellery', isPresentInStore:false, noOfProduct: "0", imgPath: "assets/images/restaurants.png"),
];