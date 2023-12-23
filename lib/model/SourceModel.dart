// ignore_for_file: public_member_api_docs, sort_constructors_first

class SourceModel {
  String id;
  String name;
  SourceModel(this.id, this.name);

  // factory SourceModel.fromJson(Map<String, dynamic> json) {
  //   return Source(id: json['id'], name: json['name']);
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      map['id'] as String,
      map['name'] as String,
    );
  }
  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(json['id'], json['name']);
  }

  // String toJson() => json.encode(toMap());

  // factory SourceModel.fromJson(String source) =>
  //     SourceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Article {
  SourceModel source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  String publishedAt;
  Article(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: SourceModel.fromMap(map['source'] as Map<String, dynamic>),
      author: map['author'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
      urlToImage: map['urlToImage'] as String,
      content: map['content'] as String,
      publishedAt: map['publishedAt'] as String,
    );
  }
  factory Article.fromJson(Map<String, dynamic> json) {
    // Article x = Article(
    //     source: SourceModel.fromJson(json['source']),
    //     author: json['author'],
    //     title: json['title'],
    //     description: json['description'],
    //     url: json['url'],
    //     urlToImage: json['urlToImage'],
    //     publishedAt: json['publishedAt'],
    //     content: json['content']);
    // print("helloe");
    // print(x.author);
    return Article(
        source: SourceModel.fromJson(json['source']),
        author: json['author'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        urlToImage: json['urlToImage'],
        publishedAt: json['publishedAt'],
        content: json['content']);
  }
  // String toJson() => json.encode(toMap());

  // factory Article.fromJson(String source) =>
  //     Article.fromMap(json.decode(source) as Map<String, dynamic>);
}
