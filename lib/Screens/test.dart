// import 'package:flutter/material.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:get/get.dart';
// import 'package:vmpa/widget/songscontoller.dart';

// import '../widget/playlistdetail.dart';

// class PlaylistPage extends StatefulWidget {
//   const PlaylistPage({Key? key}) : super(key: key);

//   @override
//   _PlaylistPageState createState() => _PlaylistPageState();
// }

// class _PlaylistPageState extends State<PlaylistPage> {
//   late List<PlaylistModel> playlists;
//   var controller = Get.put(PlayerController());

//   @override
//   void initState() {
//     super.initState();
//     loadPlaylists();
//   }

//   Future<void> loadPlaylists() async {
//     playlists = await controller.audioQuery.queryPlaylists();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF1D1B29), Color(0xFF4527A0)],
//             ),
//           ),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             title: Text('Playlists'),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//           body: playlists.isEmpty
//               ? Center(child: Text('No Playlists Found'))
//               : Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: ListView.builder(
//                     itemCount: playlists.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(32),
//                         ),
//                         child: ListTile(
//                           title: Text(
//                             playlists[index].playlist,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                           onTap: () {
//                             // Implement logic to navigate to the playlist details page
//                             // You can pass the playlist ID or other relevant information
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //     builder: (context) => PlaylistDetailsPage(
//                             //         playlist: playlists[index]),
//                             //   ),
//                             // );
//                           },
//                           trailing: IconButton(
//                             icon: Icon(
//                               Icons.play_circle_filled,
//                               color: Colors.white,
//                               size: 32,
//                             ),
//                             onPressed: () {
//                               // Implement logic to play all songs in the playlist
//                               // You can use the playlist ID to fetch songs associated with the playlist
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               showAddToPlaylistDialog(context);
//             },
//             child: Icon(Icons.add),
//           ),
//         ),
//       ],
//     );
//   }

//   void showAddToPlaylistDialog(BuildContext context) async {
//     if (playlists.isEmpty) {
//       Get.snackbar('No Playlists', 'Create a playlist first!');
//       return;
//     }

//     await Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         title: Text(
//           'Add to Playlist',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: SingleChildScrollView(
//           child: Container(
//             height: 120,
//             child: Column(
//               children: [
//                 for (var playlist in playlists)
//                   ListTile(
//                     title: Text(playlist.playlist),
//                     onTap: () {
//                       addToPlaylist(context, playlist);
//                     },
//                   ),
//               ],
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Get.back(); // Close the dialog
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void addToPlaylist(BuildContext context, PlaylistModel playlist) {
//     // Implement logic to add the song to the selected playlist using queryPlaylists() or other methods
//     // You may want to display a confirmation message or perform any necessary actions
//     Get.back(); // Close the dialog
//   }
// }
