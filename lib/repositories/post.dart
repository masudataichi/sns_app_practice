import 'dart:convert' as convert;
import 'package:flutter_sns/models/post.dart';
import 'package:http/http.dart' as http;

const url = 'https://jsonplaceholder.typicode.com';

Future<List<Post>> getPostList() async {
  final response = await http.get(
    Uri.parse('$url/posts'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> postData = convert.jsonDecode(response.body);
    final postList = postData.map((e) => Post.fromJson(e)).toList();
    return Future<List<Post>>.value(postList);
  } else {
    throw Exception('Failed to fetch data');
  }
}