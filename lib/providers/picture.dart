import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns/models/picture.dart';
import 'package:flutter_sns/repositories/common.dart';
import 'package:flutter_sns/repositories/picture.dart';

final pictureListProvider = FutureProvider.family<List<Picture>, int?>(
  (ref, albumId) async {
    return await getPictureList(albumId: albumId);
  },
);

final favoritePicturesProvider =
    ChangeNotifierProvider<FavoritePictureNotifier>(
  (ref) => FavoritePictureNotifier(),
);

class FavoritePictureNotifier extends ChangeNotifier {
  List<Picture> favoriteList = [];

  Future getFavoritePictureList() async {
    final allPictures = await getPictureList();
    favoriteList = []; 
    await Future.forEach(allPictures, (Picture item) async {
      final isFavorite = await getFavorite('picture', item.id);
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