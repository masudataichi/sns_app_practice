import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns/common_parts.dart';
import 'package:flutter_sns/models/picture.dart';
import 'package:flutter_sns/providers/common.dart';
import 'package:flutter_sns/providers/picture.dart';

class PicturesPage extends ConsumerWidget {
  const PicturesPage({Key? key}) : super(key: key);


  Future<bool> changeActiveTab(WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => state = 1);
    return Future.value(true); 
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    dynamic albumId = ModalRoute.of(context)!.settings.arguments;

    final pictureList = ref.watch(pictureListProvider(albumId));
    return WillPopScope(
      onWillPop: () => changeActiveTab(ref),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('写真'),

          automaticallyImplyLeading: albumId == null ? false : true,
        ),

        body: pictureList.when(
          data: (data) => PicturesWidget(pictureList: data),
          error: (err, stack) => Text('Error: $err'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}

class PicturesWidget extends ConsumerWidget {
  final List<Picture> pictureList; 
  final bool isMyPage;
  const PicturesWidget({
    super.key,
    required this.pictureList,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ), 
      itemCount: pictureList.length, 
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final picture = pictureList[index];
       
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(2),
              child: Image.network(picture.thumbnailUrl),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FavoriteWidget(
                id: picture.id,
                type: 'picture',
                isMyPage: isMyPage,
              ),
            ),
          ],
        );
      },
    );
  }
}