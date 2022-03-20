import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class WebScrab {
  List<ProductModel> products = [];
  int productsLength = 0;

  Future addProduct() async {
    for (var i = 0; i < productsLength; i++) {
      products.add(await extractData(i) ??
          ProductModel(
              title: "title", price: "  ", imgUrl: "image/catalog/logo2.png"));
    }
  }

  Future<ProductModel?> extractData(int productNumber) async {
    // Getting the response from the targeted url
    final response = await http.Client().get(Uri.parse(
        'https://www.sigma-computer.com/subcategory?id=1&cname=Desktop&id2=4&scname=Processors'));

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);

      try {
        // Scraping the first article title
        productsLength =
            document.getElementById("show_items")?.children.length ?? 0;
        print(productsLength);
        var responseString1 = document
            .getElementsByClassName('product-item-container')[productNumber]
            .children[1]
            .children[1];
        print(responseString1.text.trim());

        // Scraping the second article title
        var responseString2 = document
            .getElementsByClassName('product-item-container')[productNumber]
            .children[0]
            .children[0]
            .children[0]
            .children[0];
        print(responseString2.attributes.values.first.toString());

        // Scraping the third article title
        var responseString3 = document
            .getElementsByClassName('product-item-container')[productNumber]
            .children[1]
            .children[2];

        // Converting the extracted titles into
        // string and returning a list of Strings
        return ProductModel(
          title: responseString1.text.trim(),
          price: responseString3.text.trim(),
          imgUrl: responseString2.attributes.values.first.toString(),
        );
      } catch (e) {
        print(e.toString());
      }
    } else {
      print("no");
    }
  }
}
