// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/playlistcontroller.dart';
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
  var controller = Get.put(MusicController());
  final MusicController playlistController = Get.put(MusicController());

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
                                                snapshot.data![index],
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.share),
                                            title: Text('Share'),
                                            onTap: () async {
                                              Get.back();
                                              print("share");
                                              var selectedSong =
                                                  snapshot.data![index];
                                              String filePath =
                                                  selectedSong.uri;
                                              print(
                                                  "${selectedSong.displayNameWOExt}");
                                              print(filePath);
                                              final XFile file =
                                                  XFile(filePath);
                                              try {
                                                await Share.shareXFiles(
                                                  [file],
                                                  text:
                                                      'Check out this song: ${selectedSong.displayNameWOExt} by ${selectedSong.artist}',
                                                );
                                              } catch (e) {
                                                print("Error sharing: $e");
                                              }
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
        await playlistController.audioQuery.queryPlaylists();

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
                      print("add playlist");
                      bool isSongAlreadyInPlaylist = playlistController
                          .isSongInPlaylist(song, playlist.id);

                      if (isSongAlreadyInPlaylist) {
                        Get.snackbar(
                          'Info',
                          '${song.displayNameWOExt} is already in ${playlist.playlist}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                        );
                      } else {
                        await _showAddToPlaylistDialogWithSelectedPlaylist(
                          context,
                          song,
                          playlist,
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

  Future<void> _showAddToPlaylistDialogWithSelectedPlaylist(
    BuildContext context,
    SongModel song,
    PlaylistModel selectedPlaylist,
  ) async {
    // await playlistController.addSongToPlaylistAndUpdate(
    //   selectedPlaylist.id,
    //   song,
    // );

    playlistController.updatePlaylistSongsMap();

    Get.snackbar(
      'Success',
      '${song.displayNameWOExt} added to ${selectedPlaylist.playlist}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
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
                int newPlaylistId = (await playlistController.audioQuery
                    .createPlaylist(newPlaylistName)) as int;
                await playlistController.addSongToPlaylist(newPlaylistId, song);

                playlistController.updatePlaylistSongsMap();

                Get.back();
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
}
