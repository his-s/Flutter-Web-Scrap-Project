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
  WebScrab webScrab = WebScrab();
  bool isLoading = false;
  Future getList() async {
    isLoading = true;
    await webScrab.extractData(1);
    await webScrab.addProduct();
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sigma ')),
      body: ListView(
        children: List.generate(
          webScrab.products.length,
          (index) => ProductCard(
              title: webScrab.products[index].title,
              price: webScrab.products[index].price,
              imgUrl: webScrab.products[index].imgUrl),
        ),
      ),
    );
  }
}
