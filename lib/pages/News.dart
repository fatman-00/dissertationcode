import 'package:elderly_people/utils/NewsArticleAPI.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes.dart';
import '../model/SourceModel.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("News"),
        ),
        body: FutureBuilder(
          future: NewsArticleAPI.getArticle(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasData) {
              List<Article>? article = snapshot.data;
              // return Center(
              //   child: Text("success"),
              // );
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: article?.length,
                  itemBuilder: (context, index) =>
                    customListTile(article![index], context),
                    // print("damnn${article![index].content}");
                    // Text();
                  );
            } else {
              return const Center(
                child: Text("No article available"),
              );
            }
          },
        ));
  }
}
Widget customListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      Get.toNamed(Routes.singleArticle,arguments: article);
    },
    child: Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              //let's add the height

              image: DecorationImage(
                  image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              article.source.name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            article.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    ),
  );
}