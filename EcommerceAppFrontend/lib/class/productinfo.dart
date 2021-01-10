

class ProductInfo{
  String name;
  String price;
  String img;
  int categoryId;
  int id;
  String description;
  String totalQuantity;
  String unit;
  ProductInfo({
    this.id,
    this.name,
    this.price,
    this.img,
    this.description,
    this.totalQuantity,
    this.unit,
    this.categoryId
  });
  Map getProduct(){
    return {
      'name': this.name,
      'description': this.description,
      'img' : this.img,
      'unit' : this.unit,
      'price' : this.price,
      'categoryId' : this.categoryId,
      'totalQuantity': this.totalQuantity,
    };
  }
}