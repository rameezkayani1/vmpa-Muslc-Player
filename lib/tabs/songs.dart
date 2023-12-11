import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vmpa/widget/songscontoller.dart';
import '../Screens/playerScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class Songpage extends StatefulWidget {
  const Songpage({Key? key}) : super(key: key);

  @override
  State<Songpage> createState() => _SongpageState();
}

class _SongpageState extends State<Songpage> {
  var controller = Get.put(MusicController());

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
            builder: (BuildContext context,
                AsyncSnapshot<List<SongModel>> snapshot) {
              if (snapshot.hasData) {
                List<SongModel> songs = snapshot.data!;
                if (songs.isEmpty) {
                  return Center(
                    child: Text("No Songs Found"),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: ListTile(
                            title: Text(
                              "${songs[index].displayNameWOExt}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Get.to(
                                () => PlayerScreen(
                                  data: songs,
                                ),
                                transition: Transition.downToUp,
                              );
                              controller.playSong(
                                songs[index].uri,
                                index,
                              );
                            },
                            subtitle: Text(
                              " ${songs[index].artist}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
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
                                      height: 130,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ListTile(
                                              leading: Icon(Icons.share),
                                              title: Text('Share'),
                                              onTap: () async {
                                                Get.back();
                                                print("share");
                                                var selectedSong =
                                                    snapshot.data![index];
                                                String? filePath =
                                                    selectedSong.uri;
                                                print(
                                                    "${selectedSong.displayNameWOExt}");
                                                print(filePath);

                                                // Get the path to the audio file
                                                try {
                                                  await Share.shareXFiles(
                                                    [XFile(filePath!)],
                                                    text:
                                                        'Check out this song: ${selectedSong.displayNameWOExt} by ${selectedSong.artist}',
                                                  );
                                                } catch (e) {
                                                  print("Error sharing: $e");
                                                }
                                                // Check if the file path is not null or empty before sharing
                                              }),
                                          ListTile(
                                            leading: Icon(Icons.playlist_add),
                                            title: Text('Add to Playlist'),
                                            onTap: () async {
                                              Get.back();

                                              // Fetch available playlists
                                              List<PlaylistModel> playlists =
                                                  controller.playlists;

                                              // Show a dialog to select or create a playlist
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    title: Text(
                                                        'Select or Create Playlist'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          // Create a new playlist
                                                          ListTile(
                                                            leading: Icon(Icons
                                                                .playlist_add),
                                                            title: Text(
                                                              'Create New Playlist',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                            onTap: () {
                                                              Get.back();
                                                              _showCreatePlaylistDialog(
                                                                  context,
                                                                  songs[index]);
                                                            },
                                                          ),

                                                          ...playlists
                                                              .map((playlist) {
                                                            return ListTile(
                                                              leading: Icon(Icons
                                                                  .folder_copy),
                                                              title: Text(
                                                                  playlist
                                                                      .playlist),
                                                              onTap: () async {
                                                                _addSongToPlaylistAndShowSnackbar(
                                                                    playlist.id,
                                                                    songs[
                                                                        index]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          }).toList(),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
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

  void _showAddToPlaylistSnackbar(bool success) {
    String message = success
        ? 'Song added to playlist successfully'
        : 'Failed to add song to playlist';
    Get.snackbar(
      'Add to Playlist',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  // Show a dialog to create a new playlist
  void _showCreatePlaylistDialog(BuildContext context, SongModel song) {
    TextEditingController playlistNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Create New Playlist'),
          content: TextField(
            controller: playlistNameController,
            decoration: InputDecoration(labelText: 'Playlist Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String playlistName = playlistNameController.text;
                await controller.createNewPlaylist(playlistName);
                _addSongToPlaylistAndShowSnackbar(
                    controller.playlists.last.id, song);
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Add the song to the selected playlist and show a snackbar
  void _addSongToPlaylistAndShowSnackbar(int playlistId, SongModel song) {
    controller.addSongToPlaylist(playlistId, song).then((_) {
      // Successfully added to the playlist
      controller.updatePlaylistSongsMap().then((_) {
        _showAddToPlaylistSnackbar(true);
      });
    }).catchError((error) {
      // Failed to add to the playlist
      _showAddToPlaylistSnackbar(false);
    });
  }
}
