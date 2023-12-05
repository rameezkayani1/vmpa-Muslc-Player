import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widget/playlistdetail.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late OnAudioQuery audioQuery;
  late List<PlaylistModel> playlists;
  late TextEditingController playlistNameController;

  @override
  void initState() {
    super.initState();
    audioQuery = OnAudioQuery();
    playlists = [];
    playlistNameController = TextEditingController();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    List<PlaylistModel> result = await audioQuery.queryPlaylists();
    setState(() {
      playlists = result;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          body: Container(
            color: Colors.transparent,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Set the number of columns in the grid
              ),
              // padding: EdgeInsets.all(0),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaylistDetailsPage(playlist: playlists[index]),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder,
                          size: 54,
                          color: Colors.white,
                        ),
                        Text(
                          playlists[index].playlist,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightBlue,
            onPressed: () {
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
                        onPressed: () {
                          String playlistName = playlistNameController.text;
                          createNewPlaylist(playlistName);
                          Navigator.pop(context);
                        },
                        child: Text('Create'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.playlist_add),
          ),
        ),
      ],
    );
  }

  void createNewPlaylist(String playlistName) async {
    await audioQuery.createPlaylist(playlistName);
    fetchPlaylists();
  }
}
