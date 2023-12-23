import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/SourceModel.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Article article;
  String content = "";
  @override
  void initState() {
    // TODO: implement initState
    article = Get.arguments;
    content = "${article.content.substring(0, article.content.length - 15)}...";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
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
                        image: NetworkImage(article.urlToImage),
                        fit: BoxFit.cover),
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
                  article.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  //article.content.substring(0, article.content.length - 15),
                  content,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      PredefinedWidgets.myButton(context, () async {
                        final Uri _url = Uri.parse(article.url);
                        await launchUrl(_url,
                            mode: LaunchMode.externalApplication);
                      }, "View more"),
                      const SizedBox(
                        height: 10,
                      ),
                      Ink(
                        decoration: const BoxDecoration(
                          color: Colors.black, // Background color
                          shape: BoxShape
                              .circle, // You can use another shape if needed
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.white, // Icon color
                          ),
                          onPressed: () {
                            // Perform action on button press
                            PredefinedWidgets.textToSpeech(article.source.name,
                                "${article.description}  $content        For Futher information,press the view more button");
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
