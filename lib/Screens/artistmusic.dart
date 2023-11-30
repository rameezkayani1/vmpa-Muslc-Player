// artist_music_screen.dart

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
          title: Text(widget.artist.artist),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            // id: widget.artist.artist.i,
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
              List<SongModel> songs = snapshot.data!;

              return Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        songs[index].displayNameWOExt,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Get.to(
                          () => PlayerScreen(data: songs),
                          transition: Transition.downToUp,
                        );
                        controller.playSong(songs[index].uri, index);
                      },
                      subtitle: Text(
                        " ${songs[index].artist}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      leading: QueryArtworkWidget(
                        id: songs[index].id,
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
