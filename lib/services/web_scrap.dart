import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class WebScrab {
  String _getProductName(var element) {
    String value = element
        .getElementsByClassName("caption hide-cont")
        .first
        .text
        .trim()
        .toString();
    return value;
  }

  String _getProductPrice(var element) {
    String value =
        element.getElementsByClassName("price").first.text.trim().toString();
    return value;
  }

  String _getProductImgUrl(var element) {
    String value = element
        .getElementsByClassName("img-1 img-responsive")
        .first
        .attributes
        .values
        .first
        .toString();
    return value;
  }

  String _getProductStatus(var element) {
    String value = element
        .getElementsByClassName("addToCart")
        .first
        .text
        .trim()
        .toString();
    return value;
  }

  Future<List<Product>?> extractData() async {
    // Getting the response from the targeted url
    final response = await http.Client().get(Uri.parse(
        'https://www.sigma-computer.com/subcategory?id=1&cname=Desktop&id2=4&scname=Processors&page=1'));

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);

      List<Product> products = document
          .getElementById("show_items")!
          .children
          .map((e) => Product(
              title: _getProductName(e),
              price: _getProductPrice(e),
              imgUrl: _getProductImgUrl(e),
              inStock: _getProductStatus(e)))
          .toList();

      try {
        return products;
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }
}

class Product {
  final String title;
  final String price;
  final String imgUrl;
  final String inStock;

  Product(
      {required this.title,
      required this.price,
      required this.imgUrl,
      this.inStock = "In Stock"});
}
