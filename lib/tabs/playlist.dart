import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widget/playlistdetail.dart';
import '../widget/songscontoller.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  var controller = Get.find<MusicController>();

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
          body: FutureBuilder<List<PlaylistModel>>(
            future: controller.audioQuery.queryPlaylists(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PlaylistModel>> snapshot) {
              if (snapshot.hasData) {
                List<PlaylistModel> playlists = snapshot.data!;
                if (playlists.isEmpty) {
                  return Center(
                    child: Text(
                      "No Playlists Found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          3, // Adjust the number of columns as needed
                    ),
                    itemCount: playlists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to a playlist detail page or handle playlist selection
                          Get.to(() =>
                              PlaylistDetailPage(playlist: playlists[index]));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Text(
                                  playlists[index].playlist,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Handle the tap to create a new playlist
              _showCreatePlaylistDialog(context);
            },
            child: Icon(
              Icons.playlist_add,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  // Show a dialog to create a new playlist
  void _showCreatePlaylistDialog(BuildContext context) {
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
                // Handle creating a new playlist here
                await controller.createNewPlaylist(playlistName);
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
