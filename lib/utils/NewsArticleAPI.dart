import 'dart:convert';

import 'package:elderly_people/model/SourceModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

/*class NewsArticleAPI {//https://newsapi.org/v2/top-headlines/sources?apiKey=373e1d587ce74eeaa8ba0db84f865526
  static String url =
      "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=373e1d587ce74eeaa8ba0db84f865526";
  static Future<List<Article>> getArticle() async {
    print("trying");
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      //print("hello");
      Map<String, dynamic> json = jsonDecode(res.body);
      List<dynamic> body = json['articles'];
      //print(json['articles']);
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      //debugPrint("hellllloeooo");
      // for (var i = 0; i < articles.length; i++) {
      //   print(articles[i].source.name);
      // }
      return articles;
    } else {
      //print("wrong");
      throw ("Can't get the article");
    }
  }
}*/
class NewsArticleAPI {
  //let's add an Endpoint URL, you can check the website documentation
  // and learn about the different Endpoint
  //for this example I'm going to use a single endpoint

  //NOTE: make sure to use your OWN apikey, you can make a free acount and
  // choose a developer option it's FREE
  static String  endPointUrl =
      "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=373e1d587ce74eeaa8ba0db84f865526";
 
  //Now let's create the http request function
  // but first let's import the http package
 static Future<List<Article>> getArticle() async {
    print("trying");
  // <List<Article>> getArticle() async {
    //Response res = await get(endPointUrl);
    Response res = await get(Uri.parse(endPointUrl));

    //first of all let's check that we got a 200 statu code: this mean that the request was a succes
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      //this line will allow us to get the different articles from the json file and putting them into a list
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }
}