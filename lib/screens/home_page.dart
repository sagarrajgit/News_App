import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/article.dart';
import '../widget/blog_tile.dart';
import '../widget/custom_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> news = [];

  Future getNews(String countryName) async {
    news.clear();

    var response = await http.get(
      Uri.parse("https://newsapi.org/v2/top-headlines?country=$countryName&apiKey=85940a4d7b23488ba7ecd9e9e7c6533e"),
    );
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      for (var element in jsonData['articles']) {
        if (element['title'] != null && element['urlToImage'] != null) {
          final articleModel = Article(
            name: element['source']['name'] ?? 'name',
            title: element['title'] ?? 'title',
            url: element['url'] ?? 'url',
            urlToImage: element['urlToImage'] ?? 'image',
            publishedAt: element['publishedAt'] ?? 'time',
          );
          news.add(articleModel);
        }
      }
    }
  }

  String dropDownValue = 'in';
  void changeCountry(String newValue) {
    setState(() {
      dropDownValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(239, 83, 80, 1), //shade300
          title: const Text(
            'News App',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          scrolledUnderElevation: 5.0,
          shadowColor: const Color.fromRGBO(239, 83, 80, 1),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  }, 
                  icon: const Icon(Icons.search_rounded)
                ),

                // Drop down button
                Padding(
                  padding: const EdgeInsets.only(top:10, bottom: 10, right: 5.0),
                  child: DropdownButton<String>(
                    value: dropDownValue,
                    menuMaxHeight: 150,
                    alignment: Alignment.centerRight,
                    underline: Container(color: Colors.red.shade400),
                    dropdownColor: const Color.fromRGBO(239, 83, 80, 1),
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'in',
                          child: Text('India',
                              style: TextStyle(fontSize: 18, color: Colors.white))),
                      DropdownMenuItem(
                          value: 'us',
                          child: Text('USA',
                              style: TextStyle(fontSize: 18, color: Colors.white))),
                      DropdownMenuItem(
                          value: 'cn',
                          child: Text('China',
                              style: TextStyle(fontSize: 18, color: Colors.white))),
                      DropdownMenuItem(
                          value: 'jp',
                          child: Text('Japan',
                              style: TextStyle(fontSize: 18, color: Colors.white))),
                      DropdownMenuItem(
                          value: 'gb',
                          child: Text('England',
                              style: TextStyle(fontSize: 18, color: Colors.white)))
                    ],
                    onChanged: (value) => changeCountry(value!),
                  ),
                )
              ],
            ),
            // Search Icon
          ],
        ),

        // whenever we request for call it take some time to fetch data thats why i am using futurebuilder and the future we are waiting for is getNews() method
        body: FutureBuilder(
            future: getNews(dropDownValue),
            builder: (context, snapshot) {
              //snapshot use to check current request call status
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    // return blog
                    return BlogTile(
                      blogName: news[index].name,
                      blogTitle: news[index].title,
                      blogUrl: news[index].url,
                      blogUrlToImage: news[index].urlToImage,
                      blogPublishedAt: news[index].publishedAt,
                    );
                  },
                );
              }

              // if still loading then show progress indicator
              else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(239, 83, 80, 1),
                  ),
                );
              }
            }
        )
    );
  }
}
