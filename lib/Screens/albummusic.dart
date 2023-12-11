// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/Screens/playerScreen.dart';
import '../widget/songscontoller.dart';

class AlbumSongsScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumSongsScreen({required this.album});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MusicController>();

    return Stack(
      children: [
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
            backgroundColor: Colors.transparent,
            title: Text(
              "Songs in ${album.album}",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          body: FutureBuilder<List<SongModel>>(
            future: OnAudioQuery().querySongs(
              ignoreCase: true,
              sortType: null,
              uriType: UriType.EXTERNAL,
            ),
            builder: (BuildContext context,
                AsyncSnapshot<List<SongModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Songs Found for ${album.album}'));
              } else {
                List<SongModel> songs = snapshot.data!;

                // Filter songs based on the selected album
                List<SongModel> albumSongs =
                    songs.where((song) => song.albumId == album.id).toList();

                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: albumSongs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          albumSongs[index].displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                        onTap: () {
                          // Handle song tap (e.g., play the selected song)
                          Get.to(
                            () => PlayerScreen(data: albumSongs),
                            transition: Transition.downToUp,
                          );
                          controller.playSong(albumSongs[index].uri, index);
                        },
                        subtitle: Text(albumSongs[index].artist.toString()),
                        leading: QueryArtworkWidget(
                          id: albumSongs[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Icon(
                            Icons.music_note,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        // trailing: IconButton(
                        //   icon: Icon(
                        //     Icons.more_vert,
                        //     color: Colors.white,
                        //     size: 32,
                        //   ),
                        //   onPressed: () {

                        //   },
                        //   ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
