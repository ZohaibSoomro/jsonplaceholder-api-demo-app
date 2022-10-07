import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> posts = [];
  bool isLoading = false;
  final url = "https://jsonplaceholder.typicode.com/posts";
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var postData in data) {
        final post = Post.fromJson(postData);
        posts.add(post);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Demo'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    tileColor: Colors.lightBlueAccent,
                    contentPadding: const EdgeInsets.all(10.0),
                    title: Text(posts[index].title!),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PostCard(posts[index]),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post({this.body, this.id, this.title, this.userId});
  static fromJson(json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard(this.post, {Key? key}) : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.lightBlueAccent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('User Id: ${post.userId}'),
            Text('Post Id: ${post.id}'),
            Text('Title: ${post.title}'),
            Text('Body: ${post.body}'),
          ],
        ),
      ),
    );
  }
}
