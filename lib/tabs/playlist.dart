import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';

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
        body: ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                playlists[index].playlist,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              // Add onTap functionality to navigate to playlist details or play songs from the playlist.
              onTap: () {
                // Implement the desired action when a playlist is tapped.
                // For example, navigate to the playlist details page.
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PlaylistDetailsPage(playlist: playlists[index]),
                //   ),
                // );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            // Show a dialog or navigate to a new page to create a new playlist.
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Set the radius here
                  ),
                  title: Text(
                    'Create New Playlist',
                  ),
                  content: TextField(
                    controller: playlistNameController,
                    decoration: InputDecoration(labelText: 'Playlist Name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog.
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Create the new playlist using the entered name.
                        String playlistName = playlistNameController.text;
                        createNewPlaylist(playlistName);
                        Navigator.pop(context); // Close the dialog.
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
      )
    ]);
  }

  // Helper method to create a new playlist.
  void createNewPlaylist(String playlistName) async {
    await audioQuery.createPlaylist(playlistName);
    fetchPlaylists(); // Refresh the playlist list after creating a new playlist.
  }
}
