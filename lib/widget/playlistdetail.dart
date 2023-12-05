// playlist_details_page.dart

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistDetailsPage extends StatelessWidget {
  final PlaylistModel playlist;

  PlaylistDetailsPage({required this.playlist});

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
          title: Text('Playlist Details'),
        ),
        body: FutureBuilder<List<SongModel>>(
          // Fetch songs for the selected playlist
          future: fetchSongsForPlaylist(),
          builder:
              (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text(
                'No songs found in the playlist',
                style: TextStyle(color: Colors.white),
              );
            } else {
              // Display the list of songs
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                    // subtitle: Text(snapshot.data![index].artist),
                    // Add more song details as needed
                  );
                },
              );
            }
          },
        ),
      )
    ]);
  }

  // Function to fetch songs for the selected playlist
  Future<List<SongModel>> fetchSongsForPlaylist() async {
    OnAudioQuery audioQuery = OnAudioQuery();

    // Fetch all songs and filter based on the playlist ID
    List<SongModel> allSongs = await audioQuery.querySongs();
    List<SongModel> playlistSongs =
        allSongs.where((song) => song == playlist.id).toList();

    return playlistSongs;
  }
}
