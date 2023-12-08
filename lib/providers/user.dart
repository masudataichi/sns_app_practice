import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns/models/user.dart';
import 'package:flutter_sns/repositories/user.dart';


final userListProvider = FutureProvider<List<User>>(
  (ref) async {
    return await getUsers();
  },
);


final usernameProvider = StateProvider((ref) => 'ゲスト');