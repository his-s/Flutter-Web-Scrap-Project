import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Colors.green,
      scaffoldBackgroundColor: Colors.green[100],
      primaryColor: Colors.green,
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// Strings to store the extracted Article titles
  String result1 = '';
  String result2 = 'Result 2';
  String result3 = 'Result 3';
  String sigma = "https://www.sigma-computer.com/";
  bool isClicked = false;
  int totalCount = 0;
  ScrollController controller = ScrollController();

// boolean to show CircularProgressIndication
// while Web Scraping awaits
  bool isLoading = false;

  Future<List<String>> extractData() async {
    // Getting the response from the targeted url
    final response = await http.Client().get(Uri.parse(
        'https://www.sigma-computer.com/category?id=4&cname=Monitors&page=1'));

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);
      try {
        // Scraping the first article title
        var responseString1 = document
            .getElementsByClassName('product-item-container')[0]
            .children[0]
            .children[0]
            .children[0]
            .children[0];
        var count = document.getElementById("show_items")!.children.length;
        print(responseString1.attributes.values.first);
        print(count);
        setState(() {
          totalCount = count;
        });

        // Scraping the second article title
        var responseString2 = document
            .getElementsByClassName('product-item-container')[0]
            .children[1]
            .children[1];

        print(responseString2.text.trim());

        // Scraping the third article title
        var responseString3 = document
            .getElementsByClassName('product-item-container')[0]
            .children[1]
            .children[2];

        print(responseString3.text.trim());

        // Converting the extracted titles into
        // string and returning a list of Strings
        return [
          responseString1.attributes.values.first,
          responseString2.text.trim(),
          responseString3.text.trim(),
        ];
      } catch (e) {
        return ['', '', 'ERROR!'];
      }
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GeeksForGeeks')),
      body: totalCount != 0
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                controller: controller,
                itemCount: totalCount,
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      // if isLoading is true show loader
                      // else show Column of Texts
                      isLoading
                          ? CircularProgressIndicator()
                          : Column(
                              children: [
                                result1.isEmpty
                                    ? SizedBox()
                                    : Image.network(sigma + result1),
                                Text(result1,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                Text(result2,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                Text(result3,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
                    ],
                  );
                }),
              ),
            )
          : Column(
              children: [
                Text("loading...."),
                MaterialButton(
                  onPressed: () async {
                    // Setting isLoading true to show the loader
                    setState(() {
                      isLoading = true;
                      isClicked = true;
                    });

                    // Awaiting for web scraping function
                    // to return list of strings
                    final response = await extractData();

                    // Setting the received strings to be
                    // displayed and making isLoading false
                    // to hide the loader
                    setState(() {
                      result1 = response[0];
                      result2 = response[1];
                      result3 = response[2];
                      isLoading = false;
                      isClicked = false;
                    });
                  },
                  child: Text(
                    'Scrap Data',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
              ],
            ),
    );
  }
}
