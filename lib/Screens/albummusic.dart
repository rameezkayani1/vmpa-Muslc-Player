import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../widget/songscontoller.dart';

class AlbumSongsScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumSongsScreen({required this.album});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Stack(children: [
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D1B29), Color(0xFF4527A0)],
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(album.album),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: OnAudioQuery().queryAudiosFrom(
            AudiosFromType.ALBUM,
            album,
            // sortType: SortType.DEFAULT,
            orderType: OrderType.ASC_OR_SMALLER,
          ),
          builder:
              (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Songs Found for ${album.album}'));
            } else {
              List<SongModel> songs = snapshot.data!;

              return Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        songs[index].displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        // Handle song tap (e.g., play the selected song)
                        controller.playSong(songs[index].uri, index);
                      },
                      // subtitle: Text(songs[index].artist),
                      // leading: CircleAvatar(
                      //   backgroundImage: QueryArtworkWidget(
                      //     id: songs[index].id,
                      //     type: ArtworkType.AUDIO,
                      //     nullArtworkWidget: Icon(
                      //       Icons.music_note,
                      //       size: 32,
                      //     ),
                      //   ).imageProvider,
                      // ),
                    );
                  },
                ),
              );
            }
          },
        ),
      )
    ]);
  }
}
