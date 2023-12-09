import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../Screens/playerScreen.dart';
import '../widget/songscontoller.dart';

class PlaylistDetailPage extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailPage({Key? key, required this.playlist})
      : super(key: key);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  var controller = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF1D1B29), Color(0xFF4527A0)]),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Playlists',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.fetchSongsForPlaylist(widget.playlist.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
            if (snapshot.hasData) {
              List<SongModel> songs = snapshot.data!;
              if (songs.isEmpty) {
                return Center(
                  child: Text("No Songs Found in Playlist"),
                );
              } else {
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
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          songs[index].artist.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),

                        onTap: () {
                          // Navigate to the PlayerScreen and play the selected song
                          Get.to(
                            () => PlayerScreen(data: songs),
                            transition: Transition.downToUp,
                          );
                          controller.playSong(songs[index].uri, index);
                        },
                        // onTap: () {
                        //   // Play the selected song or handle the selection as needed
                        //   controller.playSong(
                        //     songs[index].uri,
                        //     index,
                        //   );
                        // },
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
      )
    ]);
  }
}
