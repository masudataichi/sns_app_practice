import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns/repositories/common.dart';
import 'package:tuple/tuple.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

final favoriteProvider =
    ChangeNotifierProvider.family<FavoriteNotifier, Tuple2<String, int>>(
  (ref, itemInfo) {
    return FavoriteNotifier(
      type: itemInfo.item1,
      id: itemInfo.item2,
    );
  },
);

class FavoriteNotifier extends ChangeNotifier {
  final String type;
  final int id;
  bool isFavorite = false;
  bool initialized = false;

  FavoriteNotifier({
    required this.type,
    required this.id,
  });

  Future getItemFavorite() async {
    isFavorite = await getFavorite(type, id);
    initialized = true;
    notifyListeners();
  }

  void setItemFavorite() async {
    setFavorite(type, id, isFavorite: isFavorite);
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

final isDarkModeProvider = ChangeNotifierProvider<IsDarkModeNotifier>(
  (ref) => IsDarkModeNotifier(),
);

class IsDarkModeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  Future getIsDarkMode() async {
    isDarkMode = await getIsDarkModeData();
    notifyListeners();
  }

  void setIsDarkMode() {
    setIsDarkModeData(currentValue: isDarkMode);
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}