// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';
import 'package:flutter/material.dart';
import '../Screens/playerScreen.dart';
import 'package:share_plus/share_plus.dart';

class Songpage1 extends StatefulWidget {
  const Songpage1({Key? key}) : super(key: key);

  @override
  State<Songpage1> createState() => _Songpage1State();
}

class _Songpage1State extends State<Songpage1> {
  var controller = Get.put(PlayerController());

  // Map to keep track of songs in playlists
  Map<int, List<int>> playlistSongsMap = {};

  @override
  Widget build(BuildContext context) {
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
              uriType: UriType.EXTERNAL,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<SongModel> snap = snapshot.data;
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No Song Found"),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: ListTile(
                            title: Text(
                              "${snapshot.data![index].displayNameWOExt}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Get.to(
                                () => PlayerScreen(
                                  data: snapshot.data!,
                                ),
                                transition: Transition.downToUp,
                              );
                              controller.playSong(
                                snapshot.data[index].uri,
                                index,
                              );
                            },
                            subtitle: Text(
                              " ${snapshot.data![index].artist}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
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
                                            onTap: () async {
                                              Get.back();
                                              await _showAddToPlaylistDialog(
                                                  context,
                                                  snapshot.data![index]);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.share),
                                            title: Text('Share'),
                                            onTap: () {
                                              Get.back();
                                              print("share");
                                              var selectedSong =
                                                  snapshot.data![index];
                                              // String filePath = selectedSong
                                              //     .filePath; // Get the path to the MP3 file

                                              // Create a message with the song details
                                              String shareMessage =
                                                  'Check out this song: ${selectedSong.displayNameWOExt} by ${selectedSong.artist}';

                                              // Share the message using the share_plus package
                                              Share.share(shareMessage);
                                            },
                                          ),
                                          SizedBox(
                                            height: 0,
                                          ),
                                          ListTile(
                                            leading:
                                                Icon(Icons.details_outlined),
                                            title: Text('Detail'),
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
                          ),
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

  Future<void> _showAddToPlaylistDialog(
    BuildContext context,
    SongModel song,
  ) async {
    List<PlaylistModel> playlists =
        await controller.audioQuery.queryPlaylists();

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          'Add to Playlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.add_box),
                  title: Text('Create New Playlist'),
                  onTap: () async {
                    Get.back();
                    await _showCreateNewPlaylistDialog(context, song);
                  },
                ),
                Divider(),
                for (var playlist in playlists)
                  ListTile(
                    leading: Icon(Icons.folder),
                    title: Text(playlist.playlist),
                    onTap: () async {
                      Get.back();

                      bool isSongAlreadyInPlaylist =
                          _isSongInPlaylist(playlist.id, song.id);

                      if (isSongAlreadyInPlaylist) {
                        // Get.back();

                        Get.snackbar(
                          'Info',
                          '${song.displayNameWOExt} is already in ${playlist.playlist}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                        );
                      } else {
                        await controller.audioQuery
                            .addToPlaylist(playlist.id, [song.id] as int);

                        // Update the map to reflect the song addition to the playlist
                        playlistSongsMap.update(
                          playlist.id,
                          (value) {
                            value.add(song.id);
                            return value;
                          },
                          ifAbsent: () => [song.id],
                        );

                        Get.back(); // Close the dialog

                        Get.snackbar(
                          'Success',
                          '${song.displayNameWOExt} added to ${playlist.playlist}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateNewPlaylistDialog(
    BuildContext context,
    SongModel song,
  ) async {
    String newPlaylistName = "";

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          'Create New Playlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                newPlaylistName = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter playlist name',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (newPlaylistName.isNotEmpty) {
                int newPlaylistId = (await controller.audioQuery
                    .createPlaylist(newPlaylistName)) as int;
                await controller.audioQuery
                    .addToPlaylist(newPlaylistId, [song.id] as int);

                // Update the map to reflect the song addition to the new playlist
                playlistSongsMap.update(
                  newPlaylistId,
                  (value) {
                    value.add(song.id);
                    return value;
                  },
                  ifAbsent: () => [song.id],
                );

                Get.back(
                    // result: PlaylistModel(
                    //     id: newPlaylistId, playlist: newPlaylistName)
                    );
              }
            },
            child: Text('Create'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Method to check if a song is in a playlist
  bool _isSongInPlaylist(int playlistId, int songId) {
    return playlistSongsMap.containsKey(playlistId) &&
        playlistSongsMap[playlistId]!.contains(songId);
  }
}
