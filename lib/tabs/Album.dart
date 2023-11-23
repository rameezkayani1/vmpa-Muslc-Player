// Iimport 'package:collection/collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';

class MusicAlbum extends StatefulWidget {
  const MusicAlbum({Key? key}) : super(key: key);

  @override
  State<MusicAlbum> createState() => _MusicAlbumState();
}

class _MusicAlbumState extends State<MusicAlbum> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFF1D1B29), Color(0xFF4527A0)]),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.INTERNAL,
            ),
            builder: (BuildContext context,
                AsyncSnapshot<List<SongModel>> snapshot) {
              if (snapshot.hasData) {
                List<SongModel> songs = snapshot.data!;
                Map<String?, List<SongModel>> albums =
                    groupBy(songs, (SongModel song) => song.album);

                if (albums.isEmpty) {
                  return Center(
                    child: Text("No Albums Found"),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: albums.length,
                      itemBuilder: (BuildContext context, int index) {
                        String? albumName = albums.keys.elementAt(index);
                        List<SongModel> albumSongs = albums[albumName]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                albumName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: albumSongs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    albumSongs[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    albumSongs[index].artist!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  leading: QueryArtworkWidget(
                                    id: albumSongs[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      controller.playSong(
                                          albumSongs[index].uri, index);
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
