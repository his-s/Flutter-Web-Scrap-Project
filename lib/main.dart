import 'package:flutter/material.dart';
import 'package:get_comp/services/web_scrap.dart';
import 'package:get_comp/widgets/product_card.dart';

void main() => runApp(
      const MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Product> products = [];
  WebScrab webScrab = WebScrab();
  @override
  void initState() {
    super.initState();
    webScrab.extractData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Sigma ')),
      body: FutureBuilder<List<Product>?>(
        future: webScrab.extractData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<Product>? products = snapshot.data;
            return ListView.builder(
                itemCount: products!.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                      title: products[index].title,
                      price: products[index].price,
                      imgUrl: products[index].imgUrl);
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
