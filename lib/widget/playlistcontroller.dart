// import 'package:get/get.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class PlaylistController extends GetxController {
//   late OnAudioQuery audioQuery;
//   List<PlaylistModel> playlists = [];
//   Map<int, List<SongModel>> playlistSongsMap = {};

//   @override
//   void onInit() {
//     super.onInit();
//     initializeController();
//   }

//   Future<void> initializeController() async {
//     audioQuery = OnAudioQuery();
//     await fetchPlaylists();
//   }

//   Future<void> fetchPlaylists() async {
//     try {
//       // Fetch playlists and update the controller
//       playlists = await audioQuery.queryPlaylists();
//       await updatePlaylistSongsMap();
//     } catch (e) {
//       print('Error fetching playlists: $e');
//       // Handle the error as needed
//     }
//   }

//   Future<void> updatePlaylistSongsMap() async {
//     // Fetch songs for each playlist and update the playlistSongsMap
//     for (var playlist in playlists) {
//       List<SongModel> songs = await fetchSongsForPlaylist(playlist.id);
//       playlistSongsMap[playlist.id] = songs;
//     }
//   }

//   Future<List<SongModel>> fetchSongsForPlaylist(int playlistId) async {
//     // Fetch all songs
//     List<SongModel> allSongs = await audioQuery.querySongs();
//     // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
//     // print(allSongs.first);
//     // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

//     // Filter songs based on the playlist ID
//     List<SongModel> playlistSongs =
//         allSongs.where((song) => song.id == playlistId).toList();

//     return playlistSongs;
//   }

//   bool isSongInPlaylist(SongModel song, int playlistId) {
//     // Check if a song is in a playlist
//     return playlistSongsMap.containsKey(playlistId) &&
//         playlistSongsMap[playlistId]!.contains(song);
//   }

//   Future<void> addSongToPlaylist(int playlistId, SongModel song) async {
//     try {
//       // Add a song to a playlist
//       await audioQuery.addToPlaylist(playlistId, song.id);

//       // Update the playlistSongsMap
//       if (playlistSongsMap.containsKey(playlistId)) {
//         playlistSongsMap[playlistId]!.add(song);
//       } else {
//         playlistSongsMap[playlistId] = [song];
//       }
//       update();
//     } catch (e) {
//       print('Error adding song to playlist: $e');
//       // Handle the error as needed
//     }
//   }
// }
