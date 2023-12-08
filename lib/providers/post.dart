import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns/models/post.dart';
import 'package:flutter_sns/repositories/common.dart';
import 'package:flutter_sns/repositories/post.dart';

final postListProvider = FutureProvider<List<Post>>(
  (ref) async {
    return await getPostList();
  },
);

final favoritePostsProvider = ChangeNotifierProvider<FavoritePostNotifier>(
  (ref) => FavoritePostNotifier(),
);

class FavoritePostNotifier extends ChangeNotifier {
  List<Post> favoriteList = [];

  Future getFavoritePostList() async {
    final allPosts = await getPostList();
    favoriteList = []; 
    await Future.forEach(allPosts, (Post item) async {
      final isFavorite = await getFavorite('post', item.id);
      if (isFavorite) {
        favoriteList.add(item);
      }
    });
    notifyListeners();
  }


  void removeMyPageFavorite(int id) {
    final removedItem = favoriteList.firstWhere((element) => element.id == id);
    favoriteList.remove(removedItem);
    notifyListeners();
  }
}