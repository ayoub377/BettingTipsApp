import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseModel {

  static final String onemonth = "one month plan";
  static final String sixmonth = "six months plan";
  static final String oneyear = "one year plan";

  String? id;
  String? price;
  String? discount;
  String? type;
  String? image;
  ProductDetails? productDetails;

  InAppPurchaseModel({this.id, this.price, this.discount, this.type, this.image, this.productDetails});

  String? getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }

  String? getPrice() {
    return price;
  }

  void setPrice(String price) {
    this.price = price;
  }

  String? getDiscount() {
    return discount;
  }

  void setDiscount(String discount) {
    this.discount = discount;
  }

  String? getType() {
    return type;
  }

  void setType(String type) {
    this.type = type;
  }

  String? getImage() {
    return image;
  }

  void setImage(String image) {
    this.image = image;
  }

  ProductDetails? getProductDetails() {
    return productDetails;
  }

  void setProductDetails(ProductDetails productDetails) {
    this.productDetails = productDetails;
  }

}
