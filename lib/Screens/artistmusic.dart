// artist_music_screen.dart

// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

import '../widget/songscontoller.dart';
import 'playerScreen.dart';

class ArtistMusicScreen extends StatefulWidget {
  final ArtistModel artist;

  const ArtistMusicScreen({required this.artist});

  @override
  _ArtistMusicScreenState createState() => _ArtistMusicScreenState();
}

class _ArtistMusicScreenState extends State<ArtistMusicScreen> {
  var controller = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.transparent,
          title: Text(widget.artist.artist),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder:
              (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No Songs Found for ${widget.artist.artist}'));
            } else {
              List<SongModel> allSongs = snapshot.data!;
              List<SongModel> artistSongs = allSongs
                  .where((song) => song.artistId == widget.artist.id)
                  .toList();

              if (artistSongs.isEmpty) {
                return Center(
                    child: Text('No Songs Found for ${widget.artist.artist}'));
              }

              return Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: artistSongs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        artistSongs[index].displayNameWOExt,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Get.to(
                          () => PlayerScreen(data: artistSongs),
                          transition: Transition.downToUp,
                        );
                        controller.playSong(artistSongs[index].uri, index);
                      },
                      subtitle: Text(
                        " ${artistSongs[index].artist}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      leading: QueryArtworkWidget(
                        id: artistSongs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 250,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.playlist_add),
                                      title: Text('Add to Playlist'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.share),
                                      title: Text('Share'),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.details_outlined),
                                      title: Text('Details'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete_forever),
                                      title: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
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
