import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  
import 'package:flutter_sns/pages/post.dart';

void main() {
    runApp(
        const ProviderScope(
            child: MySnsApp(),
        ),
    );
}

class MySnsApp extends StatelessWidget {
    const MySnsApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter SNS App',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
                '/': (context) => const PostsPage(),  
            },
        );
    }
}