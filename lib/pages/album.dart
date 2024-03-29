import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns/common_parts.dart';
import 'package:flutter_sns/models/album.dart';
import 'package:flutter_sns/providers/album.dart';
import 'package:flutter_sns/providers/common.dart';
import 'package:flutter_sns/providers/user.dart';

class AlbumsPage extends ConsumerWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumList = ref.watch(albumListProvider);  
    return Scaffold(
      appBar: AppBar(
        title: const Text('アルバム'),
        automaticallyImplyLeading: false,
      ),

      body: albumList.when(
        data: (data) => AlbumsWidget(albumList: data),
        error: (err, stack) => Text('Error: $err'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}


class AlbumsWidget extends StatelessWidget {
  final List<Album> albumList; 
  final bool isMyPage;
  const AlbumsWidget({
    super.key,
    required this.albumList,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ), 
      itemCount: albumList.length,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final album = albumList[index];

        return AlbumWidget(id: album.id, album: album, isMyPage: isMyPage);
      },
    );
  }
}

class AlbumWidget extends ConsumerWidget {
  final int id;
  final Album album;
  final bool isMyPage;

  const AlbumWidget({
    super.key,
    required this.id,
    required this.album,
    this.isMyPage = false,
  });

  void toPicturesPage(int albumId, BuildContext context, WidgetRef ref) {
    ref.read(currentTabProvider.state).update((state) => 2); 
    Navigator.of(context).pushNamed(
      '/pictures',
      arguments: albumId,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.watch(userListProvider);
    ref.read(backImgProvider(album.id)).getBackImg();  
    return GestureDetector(
      onTap: () => toPicturesPage(id, context, ref),
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              ref.watch(backImgProvider(album.id)).imgUrl,
            ),
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.6),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          
          children: userList.when(
            data: (data) => [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          data[album.userId].name,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '@${data[album.userId].username}',
                        ),
                      ),
                    ],
                  ),
                  FavoriteWidget(
                    id: id,
                    type: 'album',
                    isMyPage: isMyPage,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  album.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            error: (err, stack) => [
              Text('Error: $err'),
            ],
            loading: () => [
              const Text('loading user info...'),
            ],
          ),
        ),
      ),
    );
  }
}