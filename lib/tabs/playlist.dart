// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../widget/classmodel.dart';
// import '../widget/songscontoller.dart';

// class PlaylistsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(PlayerController());

//     // Query playlists
//     List<PlaylistModel> playlists = [];
//     // var controller = Get.put(PlayerController());

//     try {
//       playlists = controller.audioQuery.queryPlaylists() as List<PlaylistModel>;
//     } catch (e) {
//       print("Error querying playlists: $e");
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Playlists'),
//       ),
//       body: ListView.builder(
//         itemCount: playlists.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(playlists[index].playlistName),
//             // Add onTap functionality if needed
//           );
//         },
//       ),
//     );
//   }
// }